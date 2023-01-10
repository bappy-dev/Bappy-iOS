//
//  BlockJoinViewController.swift
//  Bappy
//
//  Created by 이현욱 on 2023/01/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Lottie

final class BlockJoinViewController: UIViewController {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
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
        label.text = "You need 2 hours break\nbetween hangouts"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 28.0, family: .Bold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_sulky")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "You cannot join several hangouts \nwithout 2 hours gap."
        label.numberOfLines = 0
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        label.textAlignment = .center
        return label
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyYellow
        button.setBappyTitle(
            title: "Ok",
            font: .roboto(size: 24.0, family: .Medium))
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
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "success")
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        playAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureShadow()
    }
    
    // MARK: Animations
    private func playAnimation() {
        animationView.play()
    }
    
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
    
    // MARK: Helpers
    private func configureShadow() {
        containerView.addBappyShadow(shadowOffsetHeight: 2.0)
    }
    
    private func configure() {
        view.backgroundColor = .clear
    }
    
    private func layout() {
        view.addSubviews([dimmedView, containerView])
        containerView.addSubviews([titleLabel, bappyImageView, captionLabel, okButton, animationView])
        okButton.addSubview(forwardImageView)
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(27.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46.0)
            $0.leading.trailing.equalToSuperview().inset(21.0)
        }
        
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width / 2)
            $0.height.equalTo(ScreenUtil.width / 2)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(30.0)
            $0.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(44.0)
            $0.trailing.equalToSuperview().inset(43.0)
            $0.height.equalTo(42.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(containerView.snp.top)
            $0.width.height.equalTo(80.0)
        }
    }
}
