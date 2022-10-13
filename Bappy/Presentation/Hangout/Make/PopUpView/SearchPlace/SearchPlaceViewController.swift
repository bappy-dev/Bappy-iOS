//
//  SearchPlaceViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchPlaceViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: SearchPlaceViewModel
    private let disposeBag = DisposeBag()
    
    private let maxDimmedAlpha: CGFloat = 0.3
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height - 90.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 27.0
        view.clipsToBounds = true
        return view
    }()
    
    private let dimmedView = UIView()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Close",
            font: .roboto(size: 18.0, family: .Medium),
            color: .bappyYellow)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Search place"
        return label
    }()
    
    private let searchTextField: UITextField = {
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
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchPlaceCell.self, forCellReuseIdentifier: SearchPlaceCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let bottomSpinner = UIActivityIndicatorView(style: .medium)
    private let searchBackgroundView = UIView()
    private let noResultView = NoResultView()
    
    // MARK: Lifecycle
    init(viewModel: SearchPlaceViewModel) {
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
        
        animateShowDimmedView()
        animatePresentContainer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.backgroundColor = .black
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
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        tableView.backgroundView = noResultView
        noResultView.isHidden = true
        bottomSpinner.hidesWhenStopped = true
        tableView.tableFooterView = bottomSpinner
        bottomSpinner.startAnimating()
        bottomSpinner.frame.size.height = 44.0
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
    }
    
    private func layout() {
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
            $0.leading.equalToSuperview().inset(21.0)
            $0.trailing.equalToSuperview().inset(21.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension SearchPlaceViewController {
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
        
        closeButton.rx.tap
            .bind(to: viewModel.input.closeButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.maps
            .drive(tableView.rx.items(cellIdentifier: SearchPlaceCell.reuseIdentifier, cellType: SearchPlaceCell.self)) { _, map, cell in
                cell.setupCell(with: map)
            }.disposed(by: disposeBag)
        
        viewModel.output.shouldHideNoResultView
            .skip(1)
            .distinctUntilChanged()
            .emit(to: noResultView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.dismissKeyboard
            .emit(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.dismissView
            .emit(onNext: { [weak self] _ in
                self?.animateDismissView()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.showTranslucentLoader)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldSpinnerAnimating
            .distinctUntilChanged()
            .drive(bottomSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.tableView.contentInset.bottom = height
                self?.tableView.verticalScrollIndicatorInsets.bottom = height
            }).disposed(by: disposeBag)
    }
}
