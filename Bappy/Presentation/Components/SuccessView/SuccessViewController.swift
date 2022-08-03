//
//  SuccessViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/01.
//

import UIKit
import SnapKit
import Lottie

final class SuccessViewController: UIViewController {
    
    // MARK: Properties
    private let successTitle: String
    private let successMessage: String
    private var completion: (() -> Void)?
    
    private let timeInterval: TimeInterval = 0.1
    private var leftTime = 5.0
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "success")
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 24.0, family: .Medium)
        label.textColor = .bappyBrown
        label.isHidden = true
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    init(title: String, message: String) {
        self.successTitle = title
        self.successMessage = message
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        playAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Animations
    private func playAnimation() {
        animationView.play { _ in
            UIView.animate(withDuration: 0.4, delay: 0.4, options: .transitionCrossDissolve) {
                self.titleLabel.isHidden = false
                self.timeLabel.isHidden = false
                self.view.layoutIfNeeded()
            } completion: { _ in
                
                _ = Timer.scheduledTimer(timeInterval: self.timeInterval,
                                         target: self,
                                         selector: #selector(self.onTimeFires),
                                         userInfo: nil,
                                         repeats: true)
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func onTimeFires() {
        leftTime -= timeInterval
        timeLabel.attributedText = getTimerText(time: leftTime)
        
        if messageLabel.isHidden, leftTime <= 3.6 {
            self.messageLabel.isHidden = false
        }
        
        if leftTime <= 0 {
            self.completion?()
            self.dismiss(animated: true)
        }
    }
    
    // MARK: Helpers
    private func getTimerText(time: Double) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString()
        attributedStr.append(NSAttributedString(
            string: "This page disappears in ",
            attributes: [
                .foregroundColor: UIColor.bappyBrown.withAlphaComponent(0.7),
                .font: UIFont.roboto(size: 14.0)
            ]))
        attributedStr.append(NSAttributedString(
            string: "\(Int(time))",
            attributes: [
                .foregroundColor: UIColor.bappyBrown,
                .font: UIFont.roboto(size: 16.0)
            ]))
        attributedStr.append(NSAttributedString(
            string: " seconds...",
            attributes: [
                .foregroundColor: UIColor.bappyBrown.withAlphaComponent(0.7),
                .font: UIFont.roboto(size: 14.0)
            ]))
        return attributedStr
    }
    
    private func configure() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let text = NSAttributedString(
            string: successMessage,
            attributes: [
                .foregroundColor: UIColor.bappyBrown,
                .font: UIFont.roboto(size: 14.0),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        view.backgroundColor = .white
        titleLabel.text = successTitle
        messageLabel.attributedText = text
        timeLabel.attributedText = getTimerText(time: leftTime)
    }
    
    private func layout() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.width.height.equalTo(180.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-65.0)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40.0)
        }
    }
}

extension SuccessViewController {
    func setDismissCompletion(_ completion: @escaping() -> Void) {
        self.completion = completion
    }
}
