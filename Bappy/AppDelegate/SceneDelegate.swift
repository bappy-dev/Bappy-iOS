//
//  SceneDelegate.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.tintColor = UIColor(named: "bappy_gray")
        
        // 회원가입
//        let viewModel = RegisterViewModel()
//        let viewController = RegisterViewController(viewModel: viewModel)
//        let rootViewController = UINavigationController(rootViewController: viewController)
//        rootViewController.navigationBar.isHidden = true
        
        // 회원가입 성공
//        let rootViewController = RegisterSuccessViewController()
        
        // 메인탭
        let rootViewController = BappyTabBarController()
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

