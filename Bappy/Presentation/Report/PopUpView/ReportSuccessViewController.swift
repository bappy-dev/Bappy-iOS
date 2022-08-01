//
//  ReportSuccessViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/01.
//

import UIKit
import SnapKit
import Lottie

final class ReportSuccessViewController: UIViewController {
    
    // MARK: Properties
    private var completion: (() -> Void)?
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "success")
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 24.0, family: .Medium)
        label.text = "Thanks for reporting!"
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
    
    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
                self.messageLabel.isHidden = false
                self.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self?.completion?()
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        
        let message = "Your report might have\nprevented next victim"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let text = NSAttributedString(
            string: message,
            attributes: [
                .foregroundColor: UIColor.bappyBrown,
                .font: UIFont.roboto(size: 15.0),
                .paragraphStyle: paragraphStyle
            ])
        messageLabel.attributedText = text
    }
    
    private func layout() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.width.height.equalTo(180.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-55.0)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom).offset(0)
        }
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
        }
    }
}

extension ReportSuccessViewController {
    func setDismissCompletion(_ completion: @escaping() -> Void) {
        self.completion = completion
    }
}
