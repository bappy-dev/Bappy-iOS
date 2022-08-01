//
//  ProfileSettingViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import FirebaseAuth
import RxSwift
import RxCocoa

final class ProfileSettingViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: ProfileSettingViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 36.0, family: .Bold)
        return label
    }()
    
    private let backButton = UIButton()
    
    private let notificationView: ProfileSettingNotificationView
    private let serviceView: ProfileSettingServiceView
    
    // MARK: Lifecycle
    
    init(viewModel: ProfileSettingViewModel) {
        let notificationViewModel = viewModel.subViewModels.notificationViewModel
        let serviceViewModel = viewModel.subViewModels.serviceViewModel
        self.notificationView = ProfileSettingNotificationView(viewModel: notificationViewModel)
        self.serviceView = ProfileSettingServiceView(viewModel: serviceViewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        configure()
        layout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        backButton.setImage(UIImage(named: "chevron_back"), for: .normal)
    }

    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalToSuperview().inset(10.0)
            $0.width.height.equalTo(44.0)
        }

        view.addSubview(notificationView)
        notificationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(70.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(serviceView)
        serviceView.snp.makeConstraints {
            $0.top.equalTo(notificationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileSettingViewController {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.showServiceView
            .emit(onNext: { [weak self] _ in
                let viewController = CustomerServiceViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.switchToSignInView
            .compactMap { $0 }
            .emit(onNext: { viewModel in
                do {
                    try Auth.auth().signOut()
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToSignInView(viewModel: viewModel)
                } catch {
                    fatalError("Failed sign out")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showDeleteAccountView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = DeleteAccountViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
