//
//  LocaleSearchViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "SearchPlaceCell"
final class LocaleSearchViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: LocaleSearchViewModel
    private let disposeBag = DisposeBag()
    
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
        textField.returnKeyType = .search
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchPlaceCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
        tableView.backgroundColor = .bappyLightgray
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let topSectionView = UIView()
    private let bottomSpinner = UIActivityIndicatorView(style: .medium)
    private let noResultView = NoResultView()
    
    // MARK: Lifecycle
    init(viewModel: LocaleSearchViewModel) {
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
        super.viewDidAppear(true)
        
        searchTextField.becomeFirstResponder()
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
        navigationItem.title = "Search Address"
        
        view.backgroundColor = .bappyLightgray
        topSectionView.backgroundColor = .white
        tableView.backgroundView = noResultView
        noResultView.isHidden = true
        bottomSpinner.hidesWhenStopped = true
        tableView.tableFooterView = bottomSpinner
        bottomSpinner.startAnimating()
    }
    
    private func layout() {
        let searchBackgroundView = UIView()
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
        
        view.addSubview(topSectionView)
        topSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
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
extension LocaleSearchViewController {
    private func bind() {
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(to: viewModel.input.searchButtonClicked)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $0.indexPath }
            .bind(to: viewModel.input.willDisplayIndex)
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .bind(to: viewModel.input.prefetchRows)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.maps
            .drive(tableView.rx.items) { tableView, row, map in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: IndexPath(row: row, section: 0)
                ) as! SearchPlaceCell
                cell.setupCell(with: map)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideNoResultView
            .skip(1)
            .distinctUntilChanged()
            .emit(to: noResultView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.dismissKeyboard
            .emit(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.showTranscluentLoader)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldSpinnerAnimating
            .distinctUntilChanged()
            .drive(bottomSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.tableView.contentInset.bottom = height
                self?.tableView.verticalScrollIndicatorInsets.bottom = height
            }).disposed(by: disposeBag)
    }
}
