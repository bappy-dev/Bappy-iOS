//
//  ProfileSettingNotificationView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit

final class ProfileSettingNotificationView: UIView {
    
    // MARK: Properites
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "profile_notification")
        return imageView
    }()

    private let notificationtLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Notification"
        return label
    }()

    private lazy var notificationSwitch: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "setting_switch_on"), for: .normal)
//        button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        return button
    }()

    private let myHangoutLabel: UILabel = {
        let label = UILabel()
        label.text = "My Hangout"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 16.0, family: .Medium)
        return label
    }()
    
    private let myHangoutCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "New join, New hearts, Hangout alarm"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 13.0)
        return label
    }()

    private lazy var myHangoutSwitch: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "setting_switch_on"), for: .normal)
//        button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        return button
    }()
    
    private let newHangoutLabel: UILabel = {
        let label = UILabel()
        label.text = "New Hangout"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 16.0, family: .Medium)
        return label
    }()
    
    private let newHangoutCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hangout post"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 13.0)
        return label
    }()

    private lazy var newHangoutSwitch: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "setting_switch_on"), for: .normal)
//        button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
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
