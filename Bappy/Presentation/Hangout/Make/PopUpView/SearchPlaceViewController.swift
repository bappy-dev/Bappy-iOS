//
//  SearchPlaceViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit

protocol SearchPlaceViewControllerDelegate: AnyObject {
    
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
        button.setAttributedTitle(
            NSAttributedString(
                string: "Close",
                attributes: [
                    .font: UIFont.roboto(size: 18.0, family: .Medium),
                    .foregroundColor: UIColor(named: "bappy_yellow")!]),
            for: .normal)
        button.addTarget(self, action: #selector(closeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Select place"
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a place",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
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
        tableView.separatorInset = .zero
        tableView.prefetchDataSource = self
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let searchBackgroundView = UIView()
    
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
    }
    
    // MARK: API
    private func searchGoogleMap(key: String , query: String, language: String = "en") {
        let requestDTO = MapsRequestDTO(key: key, query: query, language: language)
        let endpoint = APIEndpoints.searchGoogleMapList(with: requestDTO)

        provider.request(with: endpoint) { [weak self] result in
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

        provider.request(with: endpoint) { [weak self] result in
            switch result {
            case .success(let responseDTO):
                self?.addMaps(with: responseDTO)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func closeButtonHandler() {
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
    
    private func animateDismissView(shouldTransferPlace: Bool = false) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
//        self.delegate?.showTabBar()
//
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false) {
                if shouldTransferPlace {
//                    self.delegate?.showDetailViewController(index: self.viewModel.postIndex)
                }
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.snp.remakeConstraints {
                $0.top.equalTo(self.searchBackgroundView.snp.bottom).offset(15.0)
                $0.leading.equalToSuperview().inset(42.0)
                $0.trailing.equalToSuperview().inset(41.0)
                $0.bottom.equalToSuperview().inset(keyboardHeight + 10.0)
            }
            
            self.view.layoutIfNeeded()
        }
//        self.tableView.contentInset.bottom = keyboardHeight
//        self.tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
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
        print("DEBUG: mapList \(mapList)")
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func configure() {
        view.backgroundColor = .clear
    }
    
    private func layout() {
        
        searchBackgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
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
            $0.trailing.equalToSuperview().inset(41.0)
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
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension SearchPlaceViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("DEBUG: indexPaths \(indexPaths.map { $0.row })")
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
        searchedText = text
        nextPageToken = nil
        mapList = []
        let key = Bundle.main.googleMapAPIKey
        searchGoogleMap(key: key, query: text)
        textField.resignFirstResponder()
        return true
    }
}
