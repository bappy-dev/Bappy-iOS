//
//  SignInAlertController.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/27.
//

import UIKit
import RxSwift

final class SignInAlertController: BappyAlertController {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
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
            style: .disclosure) { [weak self] _ in
                guard let self = self,
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                let firebaseRepository = DefaultFirebaseRepository.shared
                
                let result = firebaseRepository.signOut()
                    .asObservable()
                    .share()
                
                result
                    .compactMap(getValue)
                    .bind(onNext: { _ in
                        let dependency = BappyLoginViewModel.Dependency(
                            bappyAuthRepository: DefaultBappyAuthRepository.shared,
                            firebaseRepository: firebaseRepository)
                        let viewModel = BappyLoginViewModel(dependency: dependency)
                        sceneDelegate.switchRootViewToSignInView(viewModel: viewModel)
                    })
                    .disposed(by: self.disposeBag)
                    
                result
                    .compactMap(getError)
                    .bind(onNext: { print("ERROR: \($0)")})
                    .disposed(by: self.disposeBag)
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
