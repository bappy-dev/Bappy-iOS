//
//  BappyFatalAlertView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/02.
//

import UIKit
import SnapKit

final class BappyFatalAlertView: UIView {
    
    // MARK: Properties
    private let maxDimmedAlpha: CGFloat = 0.3
    private let dimmedView = UIView()
    private let alertTitle: String
    private let alertMessage: String
    private let actionTitle: String
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 24.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_sad")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let actionButtonLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = .bappyBrown
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyYellow
        button.layer.cornerRadius = 22.0
        return button
    }()
    
    // MARK: Lifecycle
    init(title: String, message: String, actionTitle: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.actionTitle = actionTitle
        super.init(frame: UIScreen.main.bounds)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
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
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .transitionCrossDissolve) {
            self.containerView.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    private func animateDismissView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = true
            self.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK: Helpers
    private func configureShadow() {
        containerView.addBappyShadow()
        actionButton.addBappyShadow()
    }
    
    private func configure() {
        self.backgroundColor = .clear
        titleLabel.text = alertTitle
        messageLabel.text = alertMessage
        actionButtonLabel.text = actionTitle
    }
    
    private func layout() {
        let vArrangedSubviews: [UIView] = [
            titleLabel, bappyImageView, messageLabel, actionButton
        ]
        let vStackView = UIStackView(arrangedSubviews: vArrangedSubviews)
        vStackView.axis = .vertical
        vStackView.spacing = 20.0
        vStackView.alignment = .fill
        vStackView.distribution = .fillProportionally
        
        self.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(36.0)
        }
        
        containerView.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.bottom.equalToSuperview().inset(25.0)
        }
        
        actionButton.addSubview(actionButtonLabel)
        actionButtonLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(44.0)
        }
    }
}

// MARK: - Methods
extension BappyFatalAlertView {
    func show(_ handler: (() -> Void)? = nil) {
        actionButton.addAction(UIAction { [weak self] _ in
            self?.animateDismissView { handler?() }
        }, for: .touchUpInside)
        
        DispatchQueue.main.async {
            let mainWindow = UIWindow.keyWindow ?? UIWindow()
            mainWindow.addSubview(self)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateShowDimmedView()
            self.animatePresentContainer()
        }
    }
}
