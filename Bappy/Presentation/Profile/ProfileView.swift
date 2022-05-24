//
//  ProfileView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class ProfileView: UIView {
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_profile_l")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 45.5
        return imageView
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 13.0, left: 16.0, bottom: 13.0, right: 16.0)
        button.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        return button
    }()
    
    private let nameAndFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Jessica 🇺🇸"
        return label
    }()
    
    private let genderAndBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 13.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Woman / 2007.07.27"
        return label
    }()
    
    private let paymentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "payment")
        return imageView
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 13.0, left: 16.0, bottom: 13.0, right: 16.0)
        button.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        return button
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Payment"
        return label
    }()
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "notification")
        return imageView
    }()
    
    private let notificationtLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Notification"
        return label
    }()
    
    private lazy var notificationSwitch: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "switch_selected"), for: .selected)
        button.setImage(UIImage(named: "switch_unselected"), for: .normal)
        button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
//        button.isSelected = true
        return button
    }()
    
    private let messageNotificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        var attrStr = NSMutableAttributedString(
            string: "Message\n",
            attributes: [
                .foregroundColor: UIColor(named: "bappy_brown")!,
                .font: UIFont.roboto(size: 12.0)
            ])
        attrStr.append(NSAttributedString(
            string: "DM, Hangout open, etc.",
            attributes: [
                .foregroundColor: UIColor(named: "bappy_brown")!,
                .font: UIFont.roboto(size: 8.0)
            ]))
        label.attributedText = attrStr
        return label
    }()
    
    private lazy var messageNotificationSwitch: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "switch_selected"), for: .selected)
        button.setImage(UIImage(named: "switch_unselected"), for: .normal)
        button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
//        button.isSelected = true
        return button
    }()
    
    private let otherNotificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        var attrStr = NSMutableAttributedString(
            string: "Other\n",
            attributes: [
                .foregroundColor: UIColor(named: "bappy_brown")!,
                .font: UIFont.roboto(size: 12.0)
            ])
        attrStr.append(NSAttributedString(
            string: "Events, etc.",
            attributes: [
                .foregroundColor: UIColor(named: "bappy_brown")!,
                .font: UIFont.roboto(size: 8.0)
            ]))
        label.attributedText = attrStr
        return label
    }()
    
    private lazy var otherNotificationSwitch: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "switch_selected"), for: .selected)
        button.setImage(UIImage(named: "switch_unselected"), for: .normal)
        button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        return button
    }()
    
    private let faqImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "faq")
        return imageView
    }()
    
    private lazy var faqButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 13.0, left: 16.0, bottom: 13.0, right: 16.0)
        button.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        return button
    }()
    
    private let faqLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "FAQ/ Contact Us"
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Logout",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 13.0),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]),
            for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didTapProfileButton() {
        print("DEBUG: didTapProfileButton..")
    }
    
    @objc
    private func toggleSwitch(button: UIButton) {
        button.isSelected = !button.isSelected
        let normalImage = button.isSelected ? UIImage(named: "switch_selected") : UIImage(named: "switch_unselected")
        button.setImage(normalImage, for: .normal)
    }
    
    // MARK: Helpers
    private func configure() {
        
    }
    
    private func layout() {
        let dividingView1 = UIView()
        let dividingView2 = UIView()
        let dividingView3 = UIView()
        [dividingView1, dividingView2, dividingView3].forEach {
            $0.backgroundColor = .black.withAlphaComponent(0.3)
        }
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(69.0)
            $0.width.height.equalTo(91.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(nameAndFlagLabel)
        nameAndFlagLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(11.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(genderAndBirthLabel)
        genderAndBirthLabel.snp.makeConstraints {
            $0.top.equalTo(nameAndFlagLabel.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.centerY.equalTo(genderAndBirthLabel)
            $0.width.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(56.0)
        }
        
        self.addSubview(dividingView1)
        dividingView1.snp.makeConstraints {
            $0.top.equalTo(genderAndBirthLabel.snp.bottom).offset(48.0)
            $0.leading.trailing.equalToSuperview().inset(67.0)
            $0.height.equalTo(0.3)
        }
        
        self.addSubview(paymentImageView)
        paymentImageView.snp.makeConstraints {
            $0.top.equalTo(dividingView1.snp.bottom).offset(19.0)
            $0.leading.equalTo(dividingView1)
            $0.width.equalTo(20.0)
            $0.height.equalTo(16.0)
        }
        
        self.addSubview(paymentButton)
        paymentButton.snp.makeConstraints {
            $0.centerY.equalTo(paymentImageView)
            $0.width.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(56.0)
        }
        
        self.addSubview(paymentLabel)
        paymentLabel.snp.makeConstraints {
            $0.centerY.equalTo(paymentImageView)
            $0.leading.equalTo(paymentImageView.snp.trailing).offset(8.0)
        }
        
        self.addSubview(dividingView2)
        dividingView2.snp.makeConstraints {
            $0.top.equalTo(paymentImageView.snp.bottom).offset(19.0)
            $0.leading.trailing.equalToSuperview().inset(67.0)
            $0.height.equalTo(0.3)
        }
        
        self.addSubview(notificationImageView)
        notificationImageView.snp.makeConstraints {
            $0.top.equalTo(dividingView2.snp.bottom).offset(20.8)
            $0.leading.equalTo(dividingView2)
            $0.width.equalTo(20.0)
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
            $0.width.equalTo(42.0)
            $0.height.equalTo(23.0)
            $0.trailing.equalTo(dividingView2)
        }
        
        self.addSubview(messageNotificationSwitch)
        messageNotificationSwitch.snp.makeConstraints {
            $0.top.equalTo(notificationSwitch.snp.bottom).offset(22.0)
            $0.width.equalTo(42.0)
            $0.height.equalTo(23.0)
            $0.centerX.equalTo(notificationSwitch)
        }
        
        self.addSubview(otherNotificationSwitch)
        otherNotificationSwitch.snp.makeConstraints {
            $0.top.equalTo(messageNotificationSwitch.snp.bottom).offset(22.0)
            $0.width.equalTo(42.0)
            $0.height.equalTo(23.0)
            $0.centerX.equalTo(messageNotificationSwitch)
        }
        
        self.addSubview(messageNotificationLabel)
        messageNotificationLabel.snp.makeConstraints {
            $0.centerY.equalTo(messageNotificationSwitch)
            $0.leading.equalTo(notificationtLabel).offset(12.0)
        }
        
        self.addSubview(otherNotificationLabel)
        otherNotificationLabel.snp.makeConstraints {
            $0.centerY.equalTo(otherNotificationSwitch)
            $0.leading.equalTo(messageNotificationLabel)
        }
        
        self.addSubview(dividingView3)
        dividingView3.snp.makeConstraints {
            $0.top.equalTo(otherNotificationLabel.snp.bottom).offset(24.0)
            $0.leading.trailing.equalToSuperview().inset(67.0)
            $0.height.equalTo(0.3)
        }
        
        self.addSubview(faqImageView)
        faqImageView.snp.makeConstraints {
            $0.top.equalTo(dividingView3.snp.bottom).offset(19.0)
            $0.leading.equalTo(dividingView3)
            $0.width.equalTo(18.0)
            $0.height.equalTo(18.0)
        }
        
        self.addSubview(faqButton)
        faqButton.snp.makeConstraints {
            $0.centerY.equalTo(faqImageView)
            $0.width.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(56.0)
        }
        
        self.addSubview(faqLabel)
        faqLabel.snp.makeConstraints {
            $0.centerY.equalTo(faqImageView)
            $0.leading.equalTo(faqImageView.snp.trailing).offset(8.0)
        }
        
        self.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(dividingView3.snp.bottom).offset(50.0)
            $0.trailing.equalToSuperview().inset(70.0)
            $0.width.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(60.0)
        }
    }
}
