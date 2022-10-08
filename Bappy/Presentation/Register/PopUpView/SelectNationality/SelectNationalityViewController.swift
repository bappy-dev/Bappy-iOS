//
//  SelectNationalityViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectNationalityViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: SelectNationalityViewModel
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
            color: .bappyYellow
        )
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Select nationality"
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search your nationality",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
        tableView.rowHeight = 41.5
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 20.0)
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let noResultView = NoResultView()
    
    // MARK: Lifecycle
    init(viewModel: SelectNationalityViewModel) {
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
        searchTextField.resignFirstResponder()
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
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        tableView.backgroundView = noResultView
    }
    
    private func layout() {
        let searchBackgroundView = UIView()
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
        
        view.addSubviews([dimmedView, containerView])
        containerView.addSubviews([titleLabel, closeButton, searchBackgroundView, tableView])
        searchBackgroundView.addSubview(searchTextField)
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().inset(-defaultHeight)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalToSuperview().inset(35.0)
            $0.height.equalTo(44.0)
        }
        
        searchBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.trailing.equalToSuperview().inset(31.0)
            $0.height.equalTo(35.0)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.0)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(42.0)
            $0.trailing.equalToSuperview().inset(41.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension SelectNationalityViewController {
    private func bind() {
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.input.closeButtonTapped)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.searchedCountries
            .drive(tableView.rx.items(cellIdentifier: CountryCell.reuseIdentifier, cellType: CountryCell.self)) { _, country, cell in
                cell.country = country
            }.disposed(by: disposeBag)
        
        viewModel.output.dismiss
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.animateDismissView()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hideNoResultView
            .drive(noResultView.rx.isHidden)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.tableView.contentInset.bottom = height
                self.tableView.verticalScrollIndicatorInsets.bottom = height
            })
            .disposed(by: disposeBag)
    }
}
