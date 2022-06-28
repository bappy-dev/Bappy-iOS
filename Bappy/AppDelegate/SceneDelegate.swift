//
//  SceneDelegate.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import FirebaseAuth
import RxSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let firebaseRepository: FirebaseRepository = DefaultFirebaseRepository.shared
    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.tintColor = .bappyGray
        
        firebaseRepository.isUserSignedIn
            .take(1)
            .filter { !$0 }
            .bind(onNext: { print("DEBUG:: \($0)") })
            .disposed(by: disposeBag)
        
        firebaseRepository.isAnonymous
            .take(1)
            .filter { $0 }
            .bind(onNext: { print("DEBUG:: \($0)") })
            .disposed(by: disposeBag)
        
        // Check Sign In State
        guard let user = Auth.auth().currentUser else {
//            user.
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
        let viewController = BappyTabBarController(viewModel: BappyTabBarViewModel(dependency: .init()))
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
