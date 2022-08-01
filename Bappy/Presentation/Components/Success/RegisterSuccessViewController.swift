//
//  RegisterSuccessViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit
import Lottie

final class RegisterSuccessViewController: UIViewController {
    
    // MARK: Properties
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "success")
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 24.0, family: .Medium)
        label.text = "Success login"
        label.textColor = .bappyYellow
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
                self.successLabel.isHidden = false
                self.view.layoutIfNeeded()
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.width.height.equalTo(130.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50.0)
        }
        
        view.addSubview(successLabel)
        successLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom).offset(25.0)
        }
    }
}
