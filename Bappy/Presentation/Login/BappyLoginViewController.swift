//
//  BappyLoginViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/29.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import AuthenticationServices
import CryptoKit

final class BappyLoginViewController: UIViewController {
    
    // MARK: Properties
    private var currentNonce: String?
    
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
                ]), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(googleButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var facebookLoginButton: UIButton = {
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
                ]), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(facebookLoginButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
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
                ]), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(appleLoginButtonHandler), for: .touchUpInside)
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
                ]), for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
            print("DEBUG: currentUser.uid \(user.uid)")
//            user.providerData.forEach { data in
//                print("DEBUG: provider name \(data.displayName)")
//            }
        }
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
        startSignInWithGoogleFlow()
    }
    
    @objc
    private func facebookLoginButtonHandler() {
        startSignInWithFacebookFlow()
    }
    
    @objc
    private func appleLoginButtonHandler() {
        startSignInWithAppleFlow()
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

// MARK: - Firebase Sign In
extension BappyLoginViewController {
    func signInWithFirebase(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let authResult = authResult else { return }
            authResult.user.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                print("DEBUG: idToken \(idToken!)")
            }
            print("DEBUG: uid \(authResult.user.uid)")
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Google Sign In
extension BappyLoginViewController {
    func startSignInWithGoogleFlow() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }

            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            self.signInWithFirebase(with: credential)
        }
    }
}

// MARK: - Facebook Sign In
extension BappyLoginViewController {
    func startSignInWithFacebookFlow() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            guard let result = result, !result.isCancelled else {
                print("DEBUG: Facebook Sign In cancelled")
                return
            }
            
            guard let accessToken = AccessToken.current?.tokenString else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            
            self.signInWithFirebase(with: credential)
        }
    }
}


// MARK: - Apple Sign In
extension BappyLoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
                    
        return result
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension BappyLoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            self.signInWithFirebase(with: credential)
        }
    }
}
// MARK: - ASAuthorizationControllerPresentationContextProviding
extension BappyLoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
