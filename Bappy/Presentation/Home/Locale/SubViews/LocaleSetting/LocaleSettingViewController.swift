//
//  LocaleSettingViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol LocaleSettingViewControllerDelegate: AnyObject {
    func closeButtonTapped()
}
private let reuseIdentifier = "LocaleSettingCell"
final class LocaleSettingViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: LocaleSettingViewControllerDelegate?
    private var locationsList: [Location] = [
        Location(
            name: "Centum Station",
            address: "210 Haeun-daero, Haeundae-gu, Busan, South Korea",
            latitude: 35.179495,
            longitude: 129.124544,
            isSelected: false
        ),
        Location(
            name: "Pusan National University",
            address: "2 Busandaehak-ro 63beon-gil, Geumjeong-gu, Busan, South Korea",
            latitude: 35.2339681,
            longitude: 129.0806855,
            isSelected: true
        ),
        Location(
            name: "Dongseong-ro",
            address: "Dongseong-ro, Jung-gu, Daegu, South Korea",
            latitude: 35.8715163,
            longitude: 128.5959431,
            isSelected: false
        ),
        Location(
            name: "Pangyo-dong",
            address: "Pangyo-dong, Bundang-gu, Seongnam-si, Gyeonggi-do, South Korea",
            latitude: 37.3908894,
            longitude: 127.0967915,
            isSelected: false
        ),
    ]
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for address",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LocaleSettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
        tableView.backgroundColor = .bappyLightgray
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let topSectionView = UIView()
    private let currentLocaleView = LocaleSettingHeaderView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Actions
    @objc
    private func closeButtonHandler() {
        delegate?.closeButtonTapped()
    }
    
    @objc
    private func textFieldEditingDidBegin(_ textFiled: UITextField) {
        textFiled.endEditing(true)
   
        let viewController = LocaleSearchViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        navigationItem.title = "Address Setting"
        
        let closeButton = UIBarButtonItem(title: "  Close", style: .plain, target: self, action: #selector(closeButtonHandler))
        closeButton.setTitleTextAttributes([.font: UIFont.roboto(size: 18.0, family: .Medium)], for: .normal)
        navigationItem.leftBarButtonItem = closeButton
        
        let backItem = UIBarButtonItem(title: "Setting", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        view.backgroundColor = .bappyLightgray
        tableView.tableHeaderView = currentLocaleView
        currentLocaleView.frame.size.height = 90.0
        topSectionView.backgroundColor = .white
        topSectionView.addBappyShadow(shadowOffsetHeight: 1.0)
    }
    
    private func layout() {
        let searchBackgroundView = UIView()
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
        
        view.addSubview(topSectionView)
        topSectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        topSectionView.addSubview(searchBackgroundView)
        searchBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.trailing.equalToSuperview().inset(31.0)
            $0.height.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        searchBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.0)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(topSectionView.snp.bottom).offset(1.0)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - UITableViewDataSource
extension LocaleSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocaleSettingCell
        cell.bind(with: locationsList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocaleSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
