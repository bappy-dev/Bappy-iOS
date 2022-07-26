//
//  BappyLoginViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

final class BappyLoginViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
    }
    
    struct Input {
        var authCredential: AnyObserver<AuthCredential> // <-> View
        var skipButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var showLoader: Signal<Bool> // <-> View
        var switchToSignInView: Signal<BappyTabBarViewModel?> // <-> View
        var showRegisterView: Signal<RegisterViewModel?> // <-> View
        
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let showLoader$ = PublishSubject<Bool>()
    private let switchToSignInView$ = PublishSubject<BappyTabBarViewModel?>()
    private let showRegisterView$ = PublishSubject<RegisterViewModel?>()
    
    private let authCredential$ = PublishSubject<AuthCredential>()
    private let skipButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let showLoader = showLoader$
            .asSignal(onErrorJustReturn: false)
        let switchToSignInView = switchToSignInView$
            .asSignal(onErrorJustReturn: nil)
        let showRegisterView = showRegisterView$
            .asSignal(onErrorJustReturn: nil)
        
        // Input & Output
        self.input = Input(
            authCredential: authCredential$.asObserver(),
            skipButtonTapped: skipButtonTapped$.asObserver()
        )
        
        self.output = Output(
            showLoader: showLoader,
            switchToSignInView: switchToSignInView,
            showRegisterView: showRegisterView
        )
        
        // Bindind
        let signInResult = authCredential$
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .flatMap(dependency.firebaseRepository.signIn)
            .share()
        
        signInResult
            .compactMap(getAuthError)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        let tokenResult = signInResult
            .map(getAuthResult)
            .compactMap { _ in }
            .flatMap(dependency.firebaseRepository.getIDTokenForcingRefresh)
            .share()
        
        tokenResult
            .compactMap(getTokenError)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        let signInUserResult = tokenResult
            .compactMap(getToken)
            .flatMap(dependency.bappyAuthRepository.fetchCurrentUser)
            .observe(on: MainScheduler.asyncInstance)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .share()
        
        signInUserResult
            .compactMap(getUserError)
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        let signInUser = signInUserResult
            .compactMap(getUser)
            .share()
        
        let signInNormalUser = signInUser
            .filter { $0.state == .normal }
        
        signInUser
            .filter { $0.state == .notRegistered }
            .map { _ -> RegisterViewModel in
                let dependency = RegisterViewModel.Dependency(
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return RegisterViewModel(dependency: dependency)
            }
            .bind(to: showRegisterView$)
            .disposed(by: disposeBag)
        
        let anonymousResult = skipButtonTapped$
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .flatMap(dependency.firebaseRepository.signInAnonymously)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .share()
        
        let anonymousUser = anonymousResult
            .map(getAuthResult)
            .compactMap { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchAnonymousUser)
        
        anonymousResult
            .compactMap(getAuthError)
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        Observable.merge(signInNormalUser, anonymousUser)
            .map { user -> BappyTabBarViewModel in
                let dependecy = BappyTabBarViewModel.Dependency(
                    selectedIndex: 0,
                    user: user,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return BappyTabBarViewModel(dependency: dependecy)
            }
            .bind(to: switchToSignInView$)
            .disposed(by: disposeBag)
    }
}
 
private func getAuthResult(_ result: Result<AuthDataResult?, Error>) -> AuthDataResult? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getAuthError(_ result: Result<AuthDataResult?, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}

private func getToken(_ result: Result<String?, Error>) -> String? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getTokenError(_ result: Result<String?, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}

private func getUser(_ result: Result<BappyUser, Error>) -> BappyUser? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getUserError(_ result: Result<BappyUser, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}
