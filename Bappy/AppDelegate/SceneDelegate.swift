//
//  SceneDelegate.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit

import FirebaseCrashlytics

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared
    private let firebaseRepository: FirebaseRepository = DefaultFirebaseRepository.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewModel = BappyInitialViewModel()
        let viewController = BappyInitialViewController(viewModel: viewModel)
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.tintColor = .bappyGray
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        Crashlytics.crashlytics().log("Pass Scenedelegate")
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handleURL(with: URLContexts.first?.url)
    }
    
    func handleURL(with urlToOpen: URL?) {
        guard let url = urlToOpen,
              let title = url.absoluteString.split(separator: "=").last else { return }
        
        if let nav = window?.rootViewController as? BappyNavigationViewController {
            if let tabbar = nav.viewControllers.first as? BappyTabBarController {
                if let listNav = tabbar.viewControllers?[0] as? UINavigationController,
                   let listVC = listNav.viewControllers.first as? HomeListViewController {
                    listVC.viewModel.input.searchButtonTapped.onNext(())
                    if let searchVC = window?.visibleViewConroller as? HomeSearchViewController {
                        searchVC.needToOpenKeyboard = false
                        searchVC.viewModel.input.text.onNext(String(title))
                        searchVC.viewModel.input.searchButtonClicked.onNext(())
                    }
                }
            }
        }
    }
}

extension SceneDelegate {
    func switchRootViewController(_ viewController: UIViewController,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.4,
                                   options: UIView.AnimationOptions = .transitionCrossDissolve,
                                   completion: ((Bool) -> Void)? = nil) {
        guard animated else {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            return
        }
        
        UIView.transition(with: window!,
                          duration: duration,
                          options: options,
                          animations: {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }, completion: completion)
    }
    
    func switchRootViewToSignInView(viewModel: BappyLoginViewModel,
                                    animated: Bool = false,
                                    completion: ((UINavigationController?) -> Void)? = nil) {
        let naviRootViewController = BappyLoginViewController(viewModel: viewModel)
        let viewController = UINavigationController(rootViewController: naviRootViewController)
        viewController.navigationBar.isHidden = true
        viewController.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        completion?(viewController)
        
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
    
    func switchRootViewToMainView(viewModel: BappyTabBarViewModel,
                                  animated: Bool = false,
                                  completion: ((UINavigationController?) -> Void)? = nil) {
        let naviRootViewController = BappyTabBarController(viewModel: viewModel)
        let viewController = BappyNavigationViewController(rootViewController: naviRootViewController)
        viewController.navigationBar.isHidden = true
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        completion?(viewController)
        
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
