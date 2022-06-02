//
//  BappyLoginViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/29.
//

import UIKit
import SnapKit
import Firebase
import GoogleSignIn
//import FirebaseAuth

final class BappyLoginViewController: UIViewController {
    
    // MARK: Properties
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_bappy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bappyLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 9.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor(named: "bappy_lightgray")?.cgColor
        button.setImage(UIImage(named: "login_google"), for: .normal)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Sign-in with Google",
                attributes: [
                    .font: UIFont.roboto(size: 12.0),
                    .foregroundColor: UIColor(named: "bappy_gray")!
                ]),
            for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(googleButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let facebookLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 9.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor(named: "bappy_lightgray")?.cgColor
        button.setImage(UIImage(named: "login_kakao"), for: .normal)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Sign-in with facebook",
                attributes: [
                    .font: UIFont.roboto(size: 12.0),
                    .foregroundColor: UIColor(named: "bappy_gray")!
                ]),
            for: .normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 9.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor(named: "bappy_lightgray")?.cgColor
        button.setImage(UIImage(named: "login_apple"), for: .normal)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Sign-in with Apple",
                attributes: [
                    .font: UIFont.roboto(size: 12.0),
                    .foregroundColor: UIColor(named: "bappy_gray")!
                ]),
            for: .normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private lazy var loginSkipButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16.0, weight: .medium)
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.tintColor = UIColor(named: "bappy_yellow")
        button.semanticContentAttribute = .forceRightToLeft
        button.setAttributedTitle(
            NSAttributedString(
                string: "Login Skip  ",
                attributes: [
                    .font: UIFont.roboto(size: 13.0),
                    .foregroundColor: UIColor(named: "bappy_yellow")!
                ]),
            for: .normal)
        button.addTarget(self, action: #selector(skipButtonHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setButtonImageInset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func skipButtonHandler() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func googleButtonHandler() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // 1. Google Sign In
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }

            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            print("DEUBG: authentication \(authentication)")
            print("DEUBG: idToken \(idToken)")
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: authentication.accessToken)
            
            // 2. Firbase Sign In
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                guard let authResult = authResult else { return }
//                authResult.user.getIDTokenForcingRefresh(true) { idToken, error in
//                    if let error = error {
//                        print("ERROR: \(error.localizedDescription)")
//                        return
//                    }
//                    print("DEBUG: idToken \(idToken!)")
//                }
                print("DEBUG: uid \(authResult.user.uid)")
                
                self?.dismiss(animated: true)
            }
        }
    }
    
    // MARK: Helpers
    private func setButtonImageInset() {
        for button in [googleLoginButton, facebookLoginButton, appleLoginButton] {
            guard let titleWidth = button.titleLabel?.frame.width else { return }
            let inset = (button.frame.width - titleWidth) / 2 - 30.0
            button.imageEdgeInsets = .init(top: 0, left: -inset, bottom: 0, right: inset)
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [
            googleLoginButton, facebookLoginButton, appleLoginButton
        ])
        vStackView.axis = .vertical
        vStackView.spacing = 18.0
        vStackView.distribution = .fillEqually
        
        view.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-7.0)
            $0.width.equalTo(210.0)
            $0.height.equalTo(207.0)
        }
        
        view.addSubview(bappyLogoImageView)
        bappyLogoImageView.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(23.0)
            $0.center.equalToSuperview()
            $0.width.equalTo(159.0)
            $0.height.equalTo(60.0)
        }
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalTo(bappyLogoImageView.snp.bottom).offset(40.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
            $0.height.equalTo(180.0)
        }
        
        view.addSubview(loginSkipButton)
        loginSkipButton.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(44.0)
        }
    }
}
