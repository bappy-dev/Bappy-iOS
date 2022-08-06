//
//  BappyAlertController.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/14.
//

import UIKit
import SnapKit

class BappyAlertController: UIViewController {
    enum BappyStyle: String { case happy, sad, excited, service, stupid, sulky }
    
    // MARK: Properties
    var canDismissByTouch: Bool = true
    var isContentsBlurred: Bool = false {
        didSet {
            blurredView.isHidden = !isContentsBlurred
            dimmedView.isHidden = isContentsBlurred
        }
    }
    
    private var alertTitle: String?
    private var alertMessage: String?
    private var bappyStyle: BappyStyle?
    
    private var hasCancelButton: Bool = false
    
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
    
    private let blurredView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let blurredView = UIVisualEffectView(effect: effect)
        blurredView.isHidden = true
        blurredView.backgroundColor = .black.withAlphaComponent(0.5)
        return blurredView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15.0
        stackView.distribution = .fillEqually
        return stackView
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
        if canDismissByTouch && !hasCancelButton {
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
    
    private func animateDismissView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false) {
                completion?()
            }
        }
    }
    
    // MARK: Helpers
    private func getDisclosureImageView() -> UIImageView {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14.0, weight: .medium)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: configuration)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .bappyBrown
        return imageView
    }
    
    private func getAlertLabel(_ action: BappyAlertAction) -> UILabel {
        let label = UILabel()
        label.text = action.title
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = (action.style == .cancel) ? .white : .bappyBrown
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    private func getAlertButton(_ action: BappyAlertAction) -> UIButton {
        let button = UIButton()
        button.backgroundColor = (action.style == .cancel) ? .bappyCoral : .bappyYellow
        button.layer.cornerRadius = 22.0
        button.addAction(UIAction { [weak self] _ in
            self?.animateDismissView {
                action.handler?(action)
            }
        }, for: .touchUpInside)
        button.addBappyShadow()
        
        let label = getAlertLabel(action)
        button.addSubview(label)
        
        if action.style == .disclosure {
            label.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset(38.0)
                $0.trailing.greaterThanOrEqualToSuperview().inset(38.0)
                $0.height.equalTo(44.0)
            }
            
            let imageView = getDisclosureImageView()
            button.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(18.0)
            }
        } else {
            label.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset(15.0)
                $0.trailing.greaterThanOrEqualToSuperview().inset(15.0)
                $0.height.equalTo(44.0)
            }
        }
        
        return button
    }
    
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
        
        view.addSubview(blurredView)
        blurredView.snp.makeConstraints {
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
        let button = getAlertButton(action)
        buttonStackView.addArrangedSubview(button)
        
        if action.style == .cancel { hasCancelButton = true }
    }
}
