//
//  SceneDelegate.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.tintColor = .bappyGray
        
        setProgressHUDStyle()
        
        // Check Sign In State
        guard let user = Auth.auth().currentUser else {
            print("DEBUG: No user signed in")
            switchRootViewToSignInView()
            return
        }
        
        // Check Guest Mode
        guard !user.isAnonymous else {
            print("DEBUG: Anonymous user signs in")
            switchRootViewToMainView()
            return
        }
        
        // Check registerd Firebase, but not in Backend
        guard let displayName = user.displayName, displayName == user.uid else {
            do { try Auth.auth().signOut() }
            catch { fatalError("ERROR: Failed signOut") }
            switchRootViewToSignInView()
            return
        }
        
        // Sign In Registerd User
        switchRootViewToMainView()
        
        // 회원가입
//        let viewController = RegisterViewController()
//        let rootViewController = UINavigationController(rootViewController: viewController)
//        rootViewController.navigationBar.isHidden = true
        
        // 회원가입 성공
//        let rootViewController = RegisterSuccessViewController()
        
        // 메인탭
//        let rootViewController = BappyTabBarController()
        
        // 행아웃 만들기
//        let viewController = HangoutMakeViewController()
//        let rootViewController = UINavigationController(rootViewController: viewController)
        
        // 로그인
//        let rootViewController = BappyLoginViewController()
        
//        window?.rootViewController = rootViewController
//        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    private func setProgressHUDStyle() {
        ProgressHUD.animationType = .horizontalCirclesPulse
        ProgressHUD.colorBackground = .bappyYellow
        ProgressHUD.colorHUD = .bappyYellow
        ProgressHUD.colorAnimation = .bappyBrown
    }
}

extension SceneDelegate {
    func switchRootViewToSignInView(animated: Bool = false, completion: ((UINavigationController?) -> Void)? = nil) {
        let naviRootViewController = BappyLoginViewController()
        let viewController = UINavigationController(rootViewController: naviRootViewController)
        viewController.navigationBar.isHidden = true
        viewController.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        guard let completion = completion else { return }
        completion(viewController)
        
        if animated {
            UIView.transition(
                with: window!,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
    
    func switchRootViewToMainView(animated: Bool = false, completion: ((BappyTabBarController?) -> Void)? = nil) {
        let viewController = BappyTabBarController()
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        guard let completion = completion else { return }
        completion(viewController)
        
        if animated {
            UIView.transition(
                with: window!,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
}
