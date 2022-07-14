//
//  BappyAlertController.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/14.
//

import UIKit
import SnapKit

final class BappyAlertController: UIViewController {
    enum BappyStyle: String { case happy, sad, excited, service }
    
    // MARK: Properties
    var canDismissByTouch: Bool = true
    
    private var alertTitle: String?
    private var alertMessage: String?
    private var bappyStyle: BappyStyle?
    
    private var cancelAlertAction: BappyAlertAction?
    private var defaultAlertAction: BappyAlertAction?
    private var cancelButtonHandler: ((BappyAlertAction) -> Void)?
    private var defaultButtonHandler: ((BappyAlertAction) -> Void)?
    
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.isHidden = true
        return view
    }()
    
    private let dimmedView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 24.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyCoral
        button.layer.cornerRadius = 22.0
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.addBappyShadow()
        return button
    }()
    
    private let cancelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var defaultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyYellow
        button.layer.cornerRadius = 22.0
        button.isHidden = true
        button.addTarget(self, action: #selector(defaultButtonTapped), for: .touchUpInside)
        button.addBappyShadow()
        return button
    }()
    
    private let defaultTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = .bappyBrown
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Lifecycle
    init(title: String? = nil, message: String? = nil, bappyStyle: BappyStyle? = nil) {
        self.alertTitle = title
        self.alertMessage = message
        self.bappyStyle = bappyStyle
        super.init(nibName: nil, bundle: nil)
        
        confiugre()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canDismissByTouch && cancelButton.isHidden {
            animateDismissView()
        }
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
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Actions
    @objc
    private func cancelButtonTapped() {
        guard let cancelAlertAction = cancelAlertAction else { return }
        cancelButtonHandler?(cancelAlertAction)
        animateDismissView()
    }
    
    @objc
    private func defaultButtonTapped() {
        guard let defaultAlertAction = defaultAlertAction else { return }
        defaultButtonHandler?(defaultAlertAction)
        animateDismissView()
    }
    
    // MARK: Helpers
    private func confiugre() {
        self.modalPresentationStyle = .overCurrentContext
        view.backgroundColor = .clear
        containerView.addBappyShadow()
        
        titleLabel.isHidden = (alertTitle == nil)
        titleLabel.text = alertTitle
        messageLabel.isHidden = (alertMessage == nil)
        messageLabel.text = alertMessage
        let image = bappyStyle.flatMap { UIImage(named: "bappy_\($0.rawValue)") }
        bappyImageView.isHidden = (alertTitle == nil)
        bappyImageView.image = image
    }
    
    private func layout() {
        let buttonArrangedSubviews: [UIView] = [cancelButton, defaultButton]
        let buttonStackView = UIStackView(arrangedSubviews: buttonArrangedSubviews)
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 15.0
        buttonStackView.distribution = .fillEqually
        
        cancelButton.addSubview(cancelTitleLabel)
        cancelTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.height.equalTo(44.0)
        }
        
        defaultButton.addSubview(defaultTitleLabel)
        defaultTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.height.equalTo(44.0)
        }
        
        let vArrangedSubviews: [UIView] = [
            titleLabel, bappyImageView, messageLabel, buttonStackView
        ]
        let vStackView = UIStackView(arrangedSubviews: vArrangedSubviews)
        vStackView.axis = .vertical
        vStackView.spacing = 20.0
        vStackView.alignment = .fill
        vStackView.distribution = .fillProportionally
        
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
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
    }
}

extension BappyAlertController {
    func addAction(_ action: BappyAlertAction) {
        switch action.style {
        case .cancel:
            cancelButton.isHidden = false
            cancelTitleLabel.text = action.title
            cancelAlertAction = action
            cancelButtonHandler = action.handler
            
        case .default:
            defaultButton.isHidden = false
            defaultTitleLabel.text = action.title
            defaultAlertAction = action
            defaultButtonHandler = action.handler
        }
    }
}
