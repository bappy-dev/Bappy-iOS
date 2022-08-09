//
//  LanguageSettingViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = "LanguageSettingCell"
typealias LanguageSettingSectionDataSource = RxTableViewSectionedAnimatedDataSource<LanguageSettingSection>
final class LanguageSettingViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: LanguageSettingViewModel
    private let disposeBag = DisposeBag()
    
    private let closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "  Close", style: .plain, target: nil, action: nil)
        button.setTitleTextAttributes(
            [.font: UIFont.roboto(size: 18.0, family: .Medium)], for: .normal)
        return button
    }()
    
    private let editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit  ", style: .plain, target: nil, action: nil)
        button.setTitleTextAttributes(
            [.font: UIFont.roboto(size: 18.0, family: .Bold)], for: .normal)
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for language",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(LanguageSettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60.0
        tableView.separatorInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
        tableView.backgroundColor = .bappyLightgray
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let dataSource: LanguageSettingSectionDataSource = {
        let dataSource = LanguageSettingSectionDataSource { dataSource, tableView, indexPath, language -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier,
                for: indexPath
            ) as! LanguageSettingCell
            cell.bind(with: language)
            cell.selectionStyle = .none
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { _, _ in true }
        dataSource.canMoveRowAtIndexPath = { _, _ in true }
        return dataSource
    }()
    
    private let topSectionView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: LanguageSettingViewModel) {
        self.viewModel = viewModel
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
    
    // MARK: Helpers
    private func pushSearchView(viewModel: LanguageSearchViewModel) {
        view.endEditing(true)
        let viewController = LanguageSearchViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func shouldHideEditButton(_ hide: Bool) {
        navigationItem.rightBarButtonItem = hide ? nil : editButton
    }
    
    private func configureShadow() {
        topSectionView.addBappyShadow(shadowOffsetHeight: 1.0)
    }
    
    private func configure() {
        navigationItem.title = "Communication"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = editButton
        
        let backItem = UIBarButtonItem(title: "Setting", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        view.backgroundColor = .bappyLightgray
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
            $0.top.equalTo(topSectionView.snp.bottom).offset(1.0)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension LanguageSettingViewController {
    private func bind() {        
        searchTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.input.closeButtonTapped)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind(to: viewModel.input.editButtonTapped)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(to: viewModel.input.itemDeleted)
            .disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .bind(to: viewModel.input.itemMoved)
            .disposed(by: disposeBag)
        
        viewModel.output.languageSettingSection
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideEditButton
            .drive(onNext: { [weak self] hide in
                self?.shouldHideEditButton(hide)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.editButtonTitle
            .drive(editButton.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.output.showSearchView
            .compactMap { $0 }
            .emit(onNext: {[weak self] viewModel in
                self?.pushSearchView(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isEditing
            .emit(to: tableView.rx.setEditing)
            .disposed(by: disposeBag)
    }
}
