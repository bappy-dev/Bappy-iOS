//
//  ProfileSettingServiceView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileSettingServiceView: UIView {
    
    // MARK: Properites
    private let viewModel: ProfileSettingServiceViewModel
    private let disposeBag = DisposeBag()
    
    private let serviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "profile_faq")
        return imageView
    }()

    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Customer Service"
        return label
    }()

    private let serviceButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Delete Account",
            hasUnderline: true)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Logout",
            hasUnderline: true)
        return button
    }()
    
    
    // MARK: Lifecycle
    init(viewModel: ProfileSettingServiceViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = .bappyBrown
        
        self.addSubview(serviceImageView)
        serviceImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40.0)
            $0.leading.equalToSuperview().inset(34.0)
            $0.width.equalTo(19.0)
            $0.height.equalTo(19.0)
        }
        
        self.addSubview(serviceLabel)
        serviceLabel.snp.makeConstraints {
            $0.centerY.equalTo(serviceImageView)
            $0.leading.equalTo(serviceImageView.snp.trailing).offset(10.0)
        }
        
        self.addSubview(serviceButton)
        serviceButton.snp.makeConstraints {
            $0.centerY.equalTo(serviceImageView)
            $0.trailing.equalToSuperview().inset(32.0)
            $0.width.equalTo(44.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(deleteAccountButton)
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(serviceLabel.snp.bottom).offset(93.0)
            $0.trailing.equalToSuperview().inset(116.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.leading.equalTo(deleteAccountButton.snp.trailing).offset(5.8)
            $0.centerY.equalTo(deleteAccountButton)
            $0.width.equalTo(0.5)
            $0.height.equalTo(12.0)
        }
        
        self.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.leading.equalTo(dividingView.snp.trailing).offset(7.8)
            $0.centerY.equalTo(dividingView)
            $0.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
}

// MARK: - Bind
extension ProfileSettingServiceView {
    private func bind() {
        serviceButton.rx.tap
            .bind(to: viewModel.input.serviceButtonTapped)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(to: viewModel.input.logoutButtonTapped)
            .disposed(by: disposeBag)
        
        deleteAccountButton.rx.tap
            .bind(to: viewModel.input.deleteAccountButtonTapped)
            .disposed(by: disposeBag)
    }
}
