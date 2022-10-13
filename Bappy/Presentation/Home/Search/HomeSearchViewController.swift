//
//  HomeSearchViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeSearchViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: HomeSearchViewModel
    private let disposeBag = DisposeBag()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .bappyBrown
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for hangouts",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        textField.returnKeyType = .search
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HangoutCell.self, forCellReuseIdentifier:  HangoutCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 390.0 * 333.0 + 11.0
        tableView.backgroundColor = .bappyLightgray
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let bottomSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        spinner.frame.size.height = 36.0
        return spinner
    }()
    private let searchBackgroundView = UIView()
    private let noResultView = NoResultView()
    
    // MARK: Lifecycle
    init(viewModel: HomeSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = searchTextField.becomeFirstResponder()
    }
    
    // MARK: Actions
    @objc
    private func backButtonHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
        tableView.tableFooterView = bottomSpinner
    }
    
    private func layout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(9.0)
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.height.equalTo(44.0)
        }
        
        view.addSubview(searchBackgroundView)
        searchBackgroundView.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(35.0)
        }
        
        searchBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView.snp.bottom).offset(20.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension HomeSearchViewController {
    private func bind() {
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(to: viewModel.input.searchButtonClicked)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map(\.indexPath.row)
            .bind(to: viewModel.input.willDisplayRow)
            .disposed(by: disposeBag)
        
        viewModel.output.scrollToTop
            .emit(to: tableView.rx.scrollToTop)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.cellViewModels
            .drive(tableView.rx.items(cellIdentifier: HangoutCell.reuseIdentifier, cellType: HangoutCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        viewModel.output.showDetailView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HangoutDetailViewController(viewModel: viewModel)
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hideNoResultView
            .skip(1)
            .distinctUntilChanged()
            .emit(to: noResultView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.dismissKeyboard
            .emit(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.showTranslucentLoader)
            .disposed(by: disposeBag)
        
        viewModel.output.spinnerAnimating
            .distinctUntilChanged()
            .emit(to: bottomSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.spinnerAnimating
            .distinctUntilChanged()
            .emit(onNext: { [weak self] animate in
                self?.tableView.tableFooterView = animate ? self?.bottomSpinner : nil
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.tableView.contentInset.bottom = height
                self?.tableView.verticalScrollIndicatorInsets.bottom = height
            }).disposed(by: disposeBag)
    }
}
