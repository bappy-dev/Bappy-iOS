//
//  SignInAlertController.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/27.
//

import UIKit

final class SignInAlertController: BappyAlertController {
    
    // MARK: Lifecycle
    init(title: String? = nil) {
        super.init(title: title, message: nil, bappyStyle: .happy)
        
        setAlertAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setAlertAction() {
        let signInAction = BappyAlertAction(
            title: "Go to sign-in!",
            style: .disclosure) { _ in
                let firebaseRepository = DefaultFirebaseRepository.shared
                firebaseRepository.signOut { result in
                    switch result {
                    case .success():
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        let dependency = BappyLoginViewModel.Dependency(
                            bappyAuthRepository: DefaultBappyAuthRepository.shared,
                            firebaseRepository: firebaseRepository)
                        let viewModel = BappyLoginViewModel(dependency: dependency)
                        sceneDelegate?.switchRootViewToSignInView(viewModel: viewModel)
                    case .failure(let error): print("ERROR: \(error)") }
                }
        }
        self.addAction(signInAction)
    }
}

private func getValue(_ result: Result<Void, Error>) -> Void? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getError(_ result: Result<Void, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}
