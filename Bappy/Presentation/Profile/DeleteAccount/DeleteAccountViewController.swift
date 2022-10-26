//
//  DeleteAccountViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import SnapKit
import RxSwift

final class DeleteAccountViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: DeleteAccountViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete Account"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 30.0, family: .Bold)
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setBappyTitle(
            title: "Cancel",
            font: .roboto(size: 25.0, family: .Medium))
        button.backgroundColor = .bappyLightgray
        button.layer.cornerRadius = 24.5
        return button
    }()
    
    private let confirmButton = UIButton()
    
    private let firstPageView: DeleteAccountFirstPageView
    private let secondPageView: DeleteAccountSecondPageView
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: DeleteAccountViewModel) {
        let firstPageViewModel = viewModel.subViewModels.firstPageViewModel
        let secondPageViewModel = viewModel.subViewModels.secondPageViewModel
        self.firstPageView = DeleteAccountFirstPageView(viewModel: firstPageViewModel)
        self.secondPageView = DeleteAccountSecondPageView(viewModel: secondPageViewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func backButtonHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    private func configureConfirmButton(page: Int) {
        switch page {
        case 0:
            confirmButton.setBappyTitle(
                title: "Next",
                font: .roboto(size: 25.0, family: .Medium))
        case 1:
            confirmButton.setBappyTitle(
                title: "Delete",
                font: .roboto(size: 25.0, family: .Medium))
            
        default: return
        }
    }
    
    private func updateConfirmButtonState(isEnabled: Bool) {
        confirmButton.isEnabled = isEnabled
        confirmButton.backgroundColor = isEnabled ? .bappyYellow : .bappyLightgray
    }
    
    private func configure() {
        view.backgroundColor = .white
        confirmButton.layer.cornerRadius = 24.5
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = .black.withAlphaComponent(0.25)
        
        let arrangedSubviews: [UIView] = [cancelButton, confirmButton]
        let hStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 31.0
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18.0)
        }
        
        view.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(41.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(dividingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        scrollView.addSubview(firstPageView)
        firstPageView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
        }
        
        scrollView.addSubview(secondPageView)
        secondPageView.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(firstPageView.snp.trailing)
        }
        
        view.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(48.0)
            $0.height.equalTo(48.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-35.0)
        }
    }
}

// MARK: - Bind
extension DeleteAccountViewController {
    private func bind() {
        cancelButton.rx.tap
            .bind(to: viewModel.input.cancelButtonTapped)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind(to: viewModel.input.confirmButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.page
            .map(CGFloat.init)
            .map { CGPoint(x: UIScreen.main.bounds.width * $0, y: 0) }
            .drive(scrollView.rx.setContentOffset)
            .disposed(by: disposeBag)
        
        viewModel.output.page
            .drive(onNext: { [weak self] page in
                self?.configureConfirmButton(page: page)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isConfirmButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.updateConfirmButtonState(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.switchToSignInView
            .compactMap { $0 }
            .emit(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToSignInView(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
    }
}
