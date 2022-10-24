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
import RxDataSources

final class LocaleSettingViewController: UIViewController {
    
    typealias LocaleSettingSectionDataSource = RxTableViewSectionedAnimatedDataSource<LocaleSettingSection>
    
    // MARK: Properties
    private let viewModel: LocaleSettingViewModel
    private let disposeBag = DisposeBag()
    
    private let closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "  Close", style: .plain, target: nil, action: nil)
        button.setTitleTextAttributes([
            .font: UIFont.roboto(size: 18.0, family: .Medium)
            ], for: .normal)
        return button
    }()
    
    private let searchTextField: UITextField = {
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
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(LocaleSettingCell.self, forCellReuseIdentifier: LocaleSettingCell.reuseIdentifier)
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
        tableView.backgroundColor = .bappyLightgray
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let dataSource: LocaleSettingSectionDataSource = {
        let dataSource = LocaleSettingSectionDataSource { dataSource, tableView, indexPath, location -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(for: indexPath, with: LocaleSettingCell.self)
            cell.bind(with: location)
            cell.selectionStyle = .none
            return cell
        }
        dataSource.canEditRowAtIndexPath = { _, _ in true }
        dataSource.decideViewTransition = { _, _, changeSets  in
            if !changeSets.isEmpty {
                return RxDataSources.ViewTransition.animated
            }
            return RxDataSources.ViewTransition.reload
        }
        return dataSource
    }()
    
    private let topSectionView = UIView()
    private let currentLocaleView: LocaleSettingHeaderView
    
    // MARK: Lifecycle
    init(viewModel: LocaleSettingViewModel) {
        let headerViewModel = viewModel.subViewModels.headerViewModel
        self.viewModel = viewModel
        self.currentLocaleView = LocaleSettingHeaderView(viewModel: headerViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureShadow()
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Helpers
    private func configureShadow() {
        topSectionView.addBappyShadow(shadowOffsetHeight: 1.0)
    }
    
    private func configure() {
        navigationItem.title = "Location Setting"
   
        navigationItem.leftBarButtonItem = closeButton
        
        let backItem = UIBarButtonItem(title: "Setting", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        view.backgroundColor = .bappyLightgray
        tableView.tableHeaderView = currentLocaleView
        currentLocaleView.frame.size.height = 40.0
        topSectionView.backgroundColor = .white
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
            $0.top.equalTo(topSectionView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension LocaleSettingViewController {
    private func bind() {
        self.rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidBegin)
            .do { [weak self] _ in self?.searchTextField.resignFirstResponder() }
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.input.closeButtonTapped)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(to: viewModel.input.itemDeleted)
            .disposed(by: disposeBag)
        
        viewModel.output.localeSettingSection
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.showSearchView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = LocaleSearchViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
