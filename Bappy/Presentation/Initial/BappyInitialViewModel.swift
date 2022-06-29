//
//  BappyInitialViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import UIKit
import RxSwift
import RxCocoa

final class BappyInitialViewModel: ViewModelType {
    
    struct Dependency {
        let currentUserRepository: CurrentUserRepository
        let firebaseRepository: FirebaseRepository
    }
    
    struct Input {}
    
    struct Output {
        var switchToSignInView: PublishSubject<BappyLoginViewModel>
        var switchToMainView: PublishSubject<BappyTabBarViewModel>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let switchToSignInView$ = PublishSubject<BappyLoginViewModel>()
    private let switchToMainView$ = PublishSubject<BappyTabBarViewModel>()
    
    private let firbaseSignInState$: BehaviorSubject<Bool>
    private let isAnonymousUser$: BehaviorSubject<Bool>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let firbaseSignInState$ = dependency.firebaseRepository.isUserSignedIn
        let isAnonymousUser$ = dependency.firebaseRepository.isAnonymous
        
        
        
        // Input & Output
        self.input = Input()
        
        self.output = Output(
            switchToSignInView: switchToSignInView$,
            switchToMainView: switchToMainView$
        )
        
        // Bindind
        self.firbaseSignInState$ = firbaseSignInState$
        self.isAnonymousUser$ = isAnonymousUser$
        
        // Not Sign In
        firbaseSignInState$
            .filter { !$0 }
            .map { _ -> BappyLoginViewModel in
                print("DEBUG: Not Signed In")
                let dependency = BappyLoginViewModel.Dependency(
                    currentUserRepository: dependency.currentUserRepository,
                    firebaseRepository: dependency.firebaseRepository)
                return BappyLoginViewModel(dependency: dependency)
            }
            .bind(to: switchToSignInView$)
            .disposed(by: disposeBag)
        
    
        // Check Guest Mode
        isAnonymousUser$
            .filter { $0 }
            .map { _ in }
            .flatMap(dependency.currentUserRepository.fetchAnonymousUser)
            .map { element -> BappyTabBarViewModel in
                print("DEBUG: Sign In Guest Mode")
                let dependency = BappyTabBarViewModel.Dependency(
                    selectedIndex: 0,
                    profile: Profile(
                        user: element,
                        joinedHangouts: [],
                        madeHangouts: [],
                        likedHangouts: []),
                    currentUserRepository: dependency.currentUserRepository)
                return BappyTabBarViewModel(dependency: dependency)
            }
            .bind(to: switchToMainView$)
            .disposed(by: disposeBag)
    
        // Check registerd Firebase, but not in Backend
        let tokenResult = Observable
            .combineLatest(firbaseSignInState$, isAnonymousUser$)
            .filter { $0.0 && !$0.1 }
            .map { _ in }
            .flatMap(dependency.firebaseRepository.getIDTokenForcingRefresh)
            .share()
    
        tokenResult
            .map(getTokenError)
            .compactMap { $0 }
            .bind(onNext: { print("ERROR: \($0.description)") })
            .disposed(by: disposeBag)
    
        let userResult = tokenResult
            .map(getToken)
            .compactMap { $0 }
            .flatMap(dependency.currentUserRepository.fetchCurrentUser)
            .share()
    
        userResult
            .map(getUserError)
            .compactMap { $0 }
            .bind(onNext: { print("ERROR: \($0.description)") })
            .disposed(by: disposeBag)
    
        let user = userResult
            .map(getUser)
            .compactMap { $0 }
            .share()
    
        user
            .filter { $0.state == .notRegistered }
            .map { _ in }
            .flatMap(dependency.firebaseRepository.signOut)
            .map { _ -> BappyLoginViewModel in
                let dependency = BappyLoginViewModel.Dependency(
                    currentUserRepository: dependency.currentUserRepository,
                    firebaseRepository: dependency.firebaseRepository)
                return BappyLoginViewModel(dependency: dependency)
            }
            .bind(to: switchToSignInView$)
            .disposed(by: disposeBag)
    
        // Sign In Registerd User
        user
            .filter { $0.state == .normal }
            .map { user -> BappyTabBarViewModel in
                let dependecy = BappyTabBarViewModel.Dependency(
                    selectedIndex: 0,
                    profile: Profile(
                        user: user,
                        joinedHangouts: [],
                        madeHangouts: [],
                        likedHangouts: []
                    ),
                    currentUserRepository: dependency.currentUserRepository
                )
                return BappyTabBarViewModel(dependency: dependecy)
            }
            .bind(to: switchToMainView$)
            .disposed(by: disposeBag)
        
    }
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
