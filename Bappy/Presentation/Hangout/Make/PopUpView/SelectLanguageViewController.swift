//
//  SelectLanguageViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

protocol SelectLanguageViewControllerDelegate: AnyObject {
    func getSelectedLanguage(_ language: String)
}

private let reuseIdentifier = "SelectLanguageCell"
final class SelectLanguageViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: SelectLanguageViewControllerDelegate?
    private let languageList = [
        "Arabic", "Catalan", "Chinese", "Croatian", "Czech", "Danish", "Dutch", "English", "Finnish", "French", "German", "Greek", "Hebrew",
        "Hindi", "Hungarian", "Indonesian", "Italian", "Japanese", "Korean", "Malay", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Slovak", "Spanish", "Swedish", "Thai", "Turkish", "Ukrainian", "Vietnamese"
    ]
    private var searchedLanguageList: [String] = [] {
        didSet {
            noResultView.isHidden = !searchedLanguageList.isEmpty
            self.tableView.reloadData()
        }
    }
    
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
            string: "Search your language",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 41.5
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 20.0)
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let noResultView = NoResultView()
    
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
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Actions
    @objc
    private func closeButtonHandler() {
        animateDismissView()
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            searchedLanguageList = languageList
        } else {
            searchedLanguageList = languageList
                .filter { $0.contains(text) }
        }
    }
    
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
    
    private func configure() {
        view.backgroundColor = .clear
        searchedLanguageList = languageList
        tableView.backgroundView = noResultView
        noResultView.isHidden = true
    }
    
    private func layout() {
        let searchBackgroundView = UIView()
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(23.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.trailing.equalToSuperview().inset(31.0)
            $0.height.equalTo(35.0)
        }
        
        searchBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.0)
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
extension SelectLanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedLanguageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = searchedLanguageList[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "bappy_brown")
        cell.textLabel?.font = .roboto(size: 14.0)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectLanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.getSelectedLanguage(searchedLanguageList[indexPath.row])
        searchTextField.resignFirstResponder()
        animateDismissView()
    }
}
