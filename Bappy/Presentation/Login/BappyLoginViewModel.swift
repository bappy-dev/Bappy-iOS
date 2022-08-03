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
        
        // MARK: Streams
        let showLoader = showLoader$
            .asSignal(onErrorJustReturn: false)
        let switchToSignInView = switchToSignInView$
            .asSignal(onErrorJustReturn: nil)
        let showRegisterView = showRegisterView$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            authCredential: authCredential$.asObserver(),
            skipButtonTapped: skipButtonTapped$.asObserver()
        )
        
        self.output = Output(
            showLoader: showLoader,
            switchToSignInView: switchToSignInView,
            showRegisterView: showRegisterView
        )
        
        // MARK: Bindind
        // Firebase SignIn
        let signInFirebaseResult = authCredential$
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .flatMap(dependency.firebaseRepository.signIn)
            .share()
        
        signInFirebaseResult
            .compactMap(getErrorDescription)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        // Back-end SignIn
        let signInUserResult = signInFirebaseResult
            .map(getValue)
            .compactMap { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchCurrentUser)
            .observe(on: MainScheduler.asyncInstance)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .share()
        
        signInUserResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        let signInUser = signInUserResult
            .compactMap(getValue)
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
            .map(getValue)
            .compactMap { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchAnonymousUser)
        
        anonymousResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
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
