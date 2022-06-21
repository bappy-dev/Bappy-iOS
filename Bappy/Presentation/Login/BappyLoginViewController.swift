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
        button.layer.cornerRadius = 24.0
        button.backgroundColor = .white
        button.setImage(UIImage(named: "login_google"), for: .normal)
        button.setBappyTitle(
            title: "Sign in with Google",
            font: .roboto(size: 18.0, family: .Bold),
            color: .bappyGray
        )
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(googleButtonHandler), for: .touchUpInside)
        button.addBappyShadow()
        return button
    }()
    
    private lazy var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24.0
        button.backgroundColor = UIColor(red: 24.0/255.0, green: 119.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        button.setImage(UIImage(named: "login_facebook"), for: .normal)
        button.setBappyTitle(
            title: "Sign in with Facebook",
            font: .roboto(size: 18.0, family: .Bold),
            color: .white
        )
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(facebookLoginButtonHandler), for: .touchUpInside)
        button.addBappyShadow()
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24.0
        button.backgroundColor = .black
        button.setImage(UIImage(named: "login_apple"), for: .normal)
        button.setBappyTitle(
            title: "Sign in with Apple",
            font: .roboto(size: 18.0, family: .Bold),
            color: .white
        )
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(appleLoginButtonHandler), for: .touchUpInside)
        button.addBappyShadow()
        return button
    }()
    
    private lazy var loginSkipButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16.0, weight: .medium)
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setBappyTitle(
            title: "Login Skip  ",
            font: .roboto(size: 16.0, family: .Bold),
            color: .white,
            hasUnderline: true
        )
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
        showProgessHUD()
        signInAnonymously()
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
    private func showProgessHUD() {
        ProgressHUD.animationType = .horizontalCirclesPulse
        ProgressHUD.colorBackground = .bappyYellow
        ProgressHUD.colorAnimation = .bappyBrown
        ProgressHUD.show(interaction: false)
    }
    
    private func setButtonImageInset() {
        for button in [googleLoginButton, facebookLoginButton, appleLoginButton] {
            guard let titleWidth = button.titleLabel?.frame.width else { return }
            let inset = (button.frame.width - titleWidth) / 2 - 30.0
            button.imageEdgeInsets = .init(top: 0, left: -inset, bottom: 0, right: inset)
        }
        
    }
    
    private func configure() {
        view.backgroundColor = .bappyYellow
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [googleLoginButton, facebookLoginButton, appleLoginButton])
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
            $0.top.equalTo(vStackView.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
        }
    }
    
    private func showRegisterView() {
        let yearList = Array(1931...Date.thisYear-17)
            .map { String($0) }
        let monthList = Array(1...12)
            .map { String($0) }
            .map { ($0.count == 1) ? "0\($0)" : $0 }
        let dayList = Array(1...31)
            .map { String($0) }
            .map { ($0.count == 1) ? "0\($0)" : $0 }
        let country = Country(code: "KR", name: "South Korea")
        let countries = NSLocale.isoCountryCodes
            .map { NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]) }
            .map { countryCode -> Country in
                let code = String(countryCode[countryCode.index(after: countryCode.startIndex)...])
                let name = NSLocale(localeIdentifier: "en_UK")
                    .displayName(forKey: NSLocale.Key.identifier, value: countryCode) ?? ""
                return Country(code: code, name: name)
            }
        
        let dependency = RegisterViewModel.Dependency(
            numOfPage: 4,
            isButtonEnabled: false,
            nameDependency: .init(
                minimumLength: 3,
                maximumLength: 30),
            birthDependency: .init(
                year: "2000",
                month: "06",
                day: "15",
                yearList: yearList,
                monthList: monthList,
                dayList: dayList),
            country: country,
            selectnationalityDependency: .init(
                country: country,
                countries: countries)
        )
        let viewModel = RegisterViewModel(dependency: dependency)
        let viewController = RegisterViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Sign In Guest Mode
extension BappyLoginViewController {
    private func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                ProgressHUD.dismiss()
                return
            }
            
            guard let authResult = authResult else { return }
            authResult.user.getIDTokenForcingRefresh(true) { idToken, error in
                ProgressHUD.dismiss()
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                print("DEBUG: idToken \(idToken!)")
            }
            print("DEBUG: uid \(authResult.user.uid)")
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.switchRootViewToMainView(animated: true)
        }
    }
}

// MARK: - Firebase Sign In
extension BappyLoginViewController {
    private func signInWithFirebase(with credential: AuthCredential) {
        showProgessHUD()
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
                ProgressHUD.dismiss()
                
                // Resisterd in Backend
                if let displayName = authResult.user.displayName, displayName == authResult.user.uid {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToMainView(animated: true)
                } else {
                    // Not resisterd in Backend
                    self.showRegisterView()
                }
            }
        }
    }
}

// MARK: - Google Sign In
extension BappyLoginViewController {
    private func startSignInWithGoogleFlow() {
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
    private func startSignInWithFacebookFlow() {
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
    private func startSignInWithAppleFlow() {
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
