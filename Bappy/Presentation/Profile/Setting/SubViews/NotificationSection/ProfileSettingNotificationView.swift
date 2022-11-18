//
//  ProfileSettingNotificationView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileSettingNotificationView: UIView {
    
    // MARK: Properites
    private let viewModel: ProfileSettingNotificationViewModel
    private let disposeBag = DisposeBag()
    
    private let notificationSwitch = SettingSwitch()
    private let myHangoutSwitch = SettingSwitch()
    private let newHangoutSwitch = SettingSwitch()
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "profile_notification")
        return imageView
    }()

    private let notificationtLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Notification"
        return label
    }()

    private let myHangoutLabel: UILabel = {
        let label = UILabel()
        label.text = "My Hangout"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Medium)
        return label
    }()
    
    private let myHangoutCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "New join, New likes, Hangout alarm"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 13.0)
        return label
    }()

    private let newHangoutLabel: UILabel = {
        let label = UILabel()
        label.text = "New Hangout"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Medium)
        return label
    }()
    
    private let newHangoutCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "New Hangout alarm"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 13.0)
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: ProfileSettingNotificationViewModel) {
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
        dividingView.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.addSubview(notificationImageView)
        notificationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(34.0)
            $0.width.equalTo(19.0)
            $0.height.equalTo(21.0)
        }
        
        self.addSubview(notificationtLabel)
        notificationtLabel.snp.makeConstraints {
            $0.centerY.equalTo(notificationImageView)
            $0.leading.equalTo(notificationImageView.snp.trailing).offset(11.0)
        }
        
        self.addSubview(notificationSwitch)
        notificationSwitch.snp.makeConstraints {
            $0.centerY.equalTo(notificationImageView)
            $0.trailing.equalToSuperview().inset(25.0)
            $0.width.equalTo(56.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(myHangoutLabel)
        myHangoutLabel.snp.makeConstraints {
            $0.top.equalTo(notificationtLabel.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().inset(70.0)
        }
        
        self.addSubview(myHangoutCaptionLabel)
        myHangoutCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(myHangoutLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(myHangoutLabel)
        }
        
        self.addSubview(myHangoutSwitch)
        myHangoutSwitch.snp.makeConstraints {
            $0.top.equalTo(myHangoutLabel).offset(-3.0)
            $0.trailing.equalToSuperview().inset(25.0)
            $0.width.equalTo(56.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(newHangoutLabel)
        newHangoutLabel.snp.makeConstraints {
            $0.top.equalTo(myHangoutCaptionLabel.snp.bottom).offset(15.0)
            $0.leading.equalTo(myHangoutLabel)
        }
        
        self.addSubview(newHangoutCaptionLabel)
        newHangoutCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(newHangoutLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(myHangoutLabel)
        }
        
        self.addSubview(newHangoutSwitch)
        newHangoutSwitch.snp.makeConstraints {
            $0.top.equalTo(newHangoutLabel).offset(-3.0)
            $0.trailing.equalToSuperview().inset(25.0)
            $0.width.equalTo(56.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.top.equalTo(newHangoutCaptionLabel.snp.bottom).offset(38.0)
            $0.leading.equalToSuperview().inset(58.0)
            $0.trailing.equalTo(newHangoutSwitch.snp.leading).offset(-2.0)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileSettingNotificationView {
    private func bind() {
        notificationSwitch.rx.tap
            .bind(to: viewModel.input.notificationSwitchTapped)
            .disposed(by: disposeBag)
        
        myHangoutSwitch.rx.tap
            .bind(to: viewModel.input.myHangoutSwitchTapped)
            .disposed(by: disposeBag)
        
        newHangoutSwitch.rx.tap
            .bind(to: viewModel.input.newHangoutSwitchTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.notificationSwitchState
            .drive(notificationSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.output.myHangoutSwitchState
            .drive(myHangoutSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.output.newHangoutSwitchtate
            .drive(newHangoutSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}
