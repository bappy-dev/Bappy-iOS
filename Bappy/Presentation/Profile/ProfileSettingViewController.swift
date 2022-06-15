//
//  ProfileSettingViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import FirebaseAuth

final class ProfileSettingViewController: UIViewController {
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 36.0, family: .Bold)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron_back"), for: .normal)
        button.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let notificationView = ProfileSettingNotificationView()
    private let serviceView = ProfileSettingServiceView()
    
    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        configure()
        layout()
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
    private func configure() {
        view.backgroundColor = .white
        serviceView.delegate = self
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

// MARK: - ProfileSettingServiceViewDelegate
extension ProfileSettingViewController: ProfileSettingServiceViewDelegate {
    func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.switchRootViewToSignInView(animated: true)
        } catch {
            fatalError("Failed sign out")
        }
    }
}
