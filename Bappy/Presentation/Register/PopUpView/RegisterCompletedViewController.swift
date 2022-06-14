//
//  RegisterCompletedViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import UIKit
import SnapKit

protocol RegisterCompletedViewControllerDelegate: AnyObject {
    
}

final class RegisterCompletedViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: RegisterCompletedViewControllerDelegate?
    
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
        label.text = "Account completed!"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 28.0, family: .Bold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_excited")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Wanna fill in your bio?"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 16.0)
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Okay!",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 24.0, family: .Medium)
                ]), for: .normal)
        button.backgroundColor = UIColor(named: "bappy_yellow")
        button.layer.cornerRadius = 21.0
        return button
    }()
    
    private let forwardImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14.0, weight: .medium)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: configuration)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "bappy_brown")
        return imageView
    }()
    
    private let laterButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12.0, weight: .regular)
        let image = UIImage(systemName: "chevron.forward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.tintColor = UIColor(named: "bappy_brown")
        button.semanticContentAttribute = .forceRightToLeft
        button.setAttributedTitle(
            NSAttributedString(
                string: "Maybe later ",
                attributes: [
                    .font: UIFont.roboto(size: 13.0, family: .Light),
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]), for: .normal)
        return button
    }()
    
    private let completeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popup_complete")
        imageView.contentMode = .scaleAspectFit
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
            $0.leading.trailing.equalToSuperview().inset(27.0)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46.0)
            $0.leading.trailing.equalToSuperview().inset(21.0)
        }
        
        containerView.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(164.0)
            $0.height.equalTo(164.0)
        }
        
        containerView.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(30.0)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(okButton)
        okButton.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(44.0)
            $0.trailing.equalToSuperview().inset(43.0)
            $0.height.equalTo(42.0)
        }
        
        okButton.addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        containerView.addSubview(laterButton)
        laterButton.snp.makeConstraints {
            $0.top.equalTo(okButton.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        containerView.addSubview(completeImageView)
        completeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(containerView.snp.top)
        }
    }
}
