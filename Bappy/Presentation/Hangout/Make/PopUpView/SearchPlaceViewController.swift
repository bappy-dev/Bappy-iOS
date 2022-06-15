//
//  SearchPlaceViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit

protocol SearchPlaceViewControllerDelegate: AnyObject {
    func getSelectedMap(_ map: Map)
}

private let reuseIdentifier = "SearchPlaceCell"
final class SearchPlaceViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: SearchPlaceViewControllerDelegate?
    
    private var searchedText: String = ""
    private var mapList = [Map]()
    private var nextPageToken: String?
    
    private let maxDimmedAlpha: CGFloat = 0.3
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height - 90.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 27.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Close",
            font: .roboto(size: 18.0, family: .Medium),
            color: .bappyYellow
        )
        button.addTarget(self, action: #selector(closeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Select place"
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a place",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        textField.returnKeyType = .search
        textField.delegate = self
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchPlaceCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 20.0)
        tableView.prefetchDataSource = self
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let searchBackgroundView = UIView()
    private let noResultView = NoResultView()
    
    private let provider = ProviderImpl()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
        addKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.searchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: API
    private func searchGoogleMap(key: String , query: String, language: String = "en") {
        let requestDTO = MapsRequestDTO(key: key, query: query, language: language)
        let endpoint = APIEndpoints.searchGoogleMapList(with: requestDTO)
        
        ProgressHUD.show(interaction: false)
        provider.request(with: endpoint) { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
            case .success(let responseDTO):
                self?.addMaps(with: responseDTO)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    private func searchNextGoogleMap(key: String , pageToken: String, language: String = "en") {
        let requestDTO = MapsNextRequestDTO(key: key, pagetoken: pageToken, language: language)
        let endpoint = APIEndpoints.searchGoogleMapNextList(with: requestDTO)
        
        ProgressHUD.show()
        provider.request(with: endpoint) { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
            case .success(let responseDTO):
                self?.addMaps(with: responseDTO)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Actions
    @objc
    private func closeButtonHandler() {
        searchTextField.resignFirstResponder()
        animateDismissView()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Actions
    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY
        self.tableView.contentInset.bottom = keyboardHeight
        self.tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    // MARK: Helpers    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addMaps(with mapsResponseDTO: MapsResponseDTO) {
        let mapPage = mapsResponseDTO.toDomain()
        nextPageToken = mapPage.nextPageToken
        mapList += mapPage.maps
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.noResultView.isHidden = !self.mapList.isEmpty
            self.tableView.reloadData()
        }
    }
    
    private func configure() {
        view.backgroundColor = .clear
        tableView.backgroundView = noResultView
        noResultView.isHidden = true
    }
    
    private func layout() {
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
        
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().inset(-defaultHeight)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalToSuperview().inset(35.0)
            $0.height.equalTo(44.0)
        }
        
        containerView.addSubview(searchBackgroundView)
        searchBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.trailing.equalToSuperview().inset(31.0)
            $0.height.equalTo(37.0)
        }
        
        searchBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(42.0)
            $0.trailing.equalToSuperview().inset(21.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}
// MARK: - UITableViewDataSource
extension SearchPlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchPlaceCell
        cell.setupCell(with: mapList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchPlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.getSelectedMap(mapList[indexPath.row])
        animateDismissView()
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension SearchPlaceViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let pageToken = nextPageToken else { return }
        let rows = indexPaths.map { $0.row + 1 }
        let key = Bundle.main.googleMapAPIKey
        if rows.contains(mapList.count) {
            nextPageToken = nil
            searchNextGoogleMap(key: key, pageToken: pageToken)
        }
    }
}


// MARK: - UITextFieldDelegate
extension SearchPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.isEmpty,
              text.lowercased() != searchedText.lowercased()
        else { return false }
        textField.resignFirstResponder()
        searchedText = text
        nextPageToken = nil
        mapList = []
        let key = Bundle.main.googleMapAPIKey
        searchGoogleMap(key: key, query: text)
        return true
    }
}
