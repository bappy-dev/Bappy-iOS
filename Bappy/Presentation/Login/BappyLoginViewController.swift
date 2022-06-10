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
                ]),
            for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(facebookLoginButtonHandler), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
            print("DEBUG: currentUser.uid \(user.uid)")
            user.providerData.forEach { data in
//                print("DEBUG: provider name \(data.displayName)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: API
    private func signIn(name: String, password: String ,completion: @escaping(String) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "172.30.1.39:8080"
        components.path = "/account"
        components.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "password", value: password)
        ]
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let returnValue = String(data: data, encoding: .utf8)  else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }

            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(returnValue)
            case (400...499):
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599):
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                """)
            }
        }

        dataTask.resume()
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
//            print("DEUBG: idToken \(idToken)")
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: authentication.accessToken)
            print("DEBUG: accessToken \(authentication.accessToken)")
            
            // 2. Firbase Sign In
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                guard let authResult = authResult else { return }
//                authResult.user.getIDToken(
                authResult.user.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                        return
                    }
                    print("DEBUG: idToken \(idToken!)")
                }
                print("DEBUG: uid \(authResult.user.uid)")
                
//                self?.signIn(name: idToken, password: idToken, completion: { returnValue in
//                    print("DEBUG: returnValue \(returnValue)")
//
//                    self?.dismiss(animated: true)
//                })
                self?.dismiss(animated: true)
            }
        }
    }
    
    @objc
    private func facebookLoginButtonHandler() {
        
        // 1. Facebook Sign In
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { [weak self] result, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            guard let result = result, !result.isCancelled else {
                print("DEBUG: Cancelled")
                return
            }
            print("DEBUG: \(result.token!)")
            guard let accessToken = AccessToken.current?.tokenString else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            print("DEBUG: AccessToken \(accessToken)")

            // 2. Firebase Sign In
            Auth.auth().signIn(with: credential) { authResult, error in
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
