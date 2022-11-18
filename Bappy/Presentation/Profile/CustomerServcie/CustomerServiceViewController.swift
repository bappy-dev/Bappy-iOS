//
//  CustomerServiceViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit
import MessageUI

final class CustomerServiceViewController: UIViewController {
    
    // MARK: Properties
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .bappyBrown
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Us"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 30.0, family: .Bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 20.0)
        label.numberOfLines = 4
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let emailButton = CustomerServiceButton(title: "Send us e-mail")
    private let instaButton = CustomerServiceButton(title: "DM us on Instagram")
    private let kakaoButton = CustomerServiceButton(title: "DM us on Kakao channel")
    
    private let bappyImageView = UIImageView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
    
    @objc
    private func emailButtonHandler() {
        if MFMailComposeViewController.canSendMail() {
            guard let info = Bundle.main.infoDictionary,
                  let appVersion = info["CFBundleShortVersionString"] as? String else { return }
            let osVersion = UIDevice.current.systemVersion
            let device = getModel()
            
            let numOfDot = Int((UIScreen.main.bounds.width - 20.0) / 8.8)
            let dottedLine = String.init(repeating: "-", count: numOfDot)
            
            let message = """
- Please fill out the information
below to understand the exact inquiry!\n\n\n
1. Issue situation:\n\n2. Details:\n\n
- OS version: iOS \(osVersion)
- App version: iOS \(appVersion)
- Device: \(device)\n\nIf you attach a screenshot of your inquiry,\nwe can check it quickly.\n\n\n
\(dottedLine)\n\n\nBappy can collect and use personal information and
contact information included in the inquiry. However,
this information will only be processed for answer
purposes. For more information, please refer to the
personal information processing policy on the
Bappy app's My Page
"""
            
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            
            viewController.setToRecipients(["newrience@gmail.com"])
            viewController.setSubject("[Bappy] Inquiries & Suggestions")
            viewController.setMessageBody(message, isHTML: false)
            viewController.view.tintColor = .systemBlue
            
            self.present(viewController, animated: true)
        } else {
            // Alert
        }
    }
    
    @objc
    private func instaButtonHandler() {
        if let url = URL(string: "https://instagram.com/bappy_korea?utm_medium=copy_link") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc
    private func kakaoButtonHandler() {
        if let url = URL(string: "http://pf.kakao.com/_xbxlRxjb/chat") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: Helpers
    private func getModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
    
    private func configure() {
        view.backgroundColor = .white
        bappyImageView.image = UIImage(named: "bappy_service")
        descriptionLabel.text = "We profoundly appreciate your feedback. Please don’t hesitate.\nAlso, feel free to ask us if you have any difficulty, using our app."
        emailButton.addTarget(self, action: #selector(emailButtonHandler), for: .touchUpInside)
        instaButton.addTarget(self, action: #selector(instaButtonHandler), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(kakaoButtonHandler), for: .touchUpInside)
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = .black.withAlphaComponent(0.25)
        
        let arrangedSubviews: [UIView] = [emailButton, instaButton, kakaoButton]
        let vStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 3.0
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18.0)
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.height.equalTo(44.0)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
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
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        contentView.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33.0)
            $0.leading.equalToSuperview().inset(35.0)
            $0.trailing.equalToSuperview().inset(33.0)
            $0.height.equalTo(126.0)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(18.0)
            $0.leading.equalToSuperview().inset(58.0)
            $0.trailing.equalToSuperview().inset(54.0)
        }
        
        contentView.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(35.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40.0)
            $0.width.equalTo(211.0)
            $0.height.equalTo(294.0)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension CustomerServiceViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
