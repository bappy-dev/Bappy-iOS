//
//  SigninPopupViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

protocol SigninPopupViewControllerDelegate: AnyObject {
    
}

final class SigninPopupViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: SigninPopupViewControllerDelegate?
    
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.isHidden = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please sign in to join!"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 24.0, family: .Medium)
        label.textAlignment = .center
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_happy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let signinButton: UIButton = {
        let button = UIButton()
        button.setBappyTitle(
            title: "Go to sign-in!",
            font: .roboto(size: 20.0, family: .Bold)
        )
        button.backgroundColor = .bappyYellow
        button.layer.cornerRadius = 21.0
        return button
    }()
    
    private let forwardImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14.0, weight: .medium)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: configuration)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .bappyBrown
        return imageView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateDismissView()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
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
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        containerView.addBappyShadow(shadowOffsetHeight: 2.0)
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(36.0)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.leading.trailing.equalToSuperview().inset(41.0)
        }
        
        containerView.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(195.0)
            $0.height.equalTo(184.0)
        }
        
        containerView.addSubview(signinButton)
        signinButton.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(25.0)
            $0.leading.trailing.equalToSuperview().inset(29.0)
            $0.height.equalTo(42.0)
            $0.bottom.equalToSuperview().inset(35.0)
        }
        
        signinButton.addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18.0)
        }
    }
}
