//
//  CustomerServiceViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

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
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        bappyImageView.image = UIImage(named: "bappy_service")
        descriptionLabel.text = "We profoundly appreciate your feedback. Please don’t hesitate.\nAlso, feel free to ask us if you have any difficulty, using our app."
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(9.0)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(53.0)
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
            $0.top.equalToSuperview().inset(56.0)
            $0.leading.equalToSuperview().inset(35.0)
            $0.trailing.equalToSuperview().inset(33.0)
            $0.height.equalTo(126.0)
        }
        
        contentView.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(53.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(211.0)
            $0.height.equalTo(294.0)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(35.0)
            $0.leading.equalToSuperview().inset(58.0)
            $0.trailing.equalToSuperview().inset(54.0)
            $0.bottom.equalToSuperview().inset(40.0)
        }
    }
}
