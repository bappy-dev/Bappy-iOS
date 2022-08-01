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
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
    }
    
    struct Input {}
    
    struct Output {
        var switchToSignInView: Signal<BappyLoginViewModel?> // <-> View
        var switchToMainView: Signal<BappyTabBarViewModel?> // <-> View
        var showAlert: Signal<Alert?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let switchToSignInView$ = PublishSubject<BappyLoginViewModel?>()
    private let switchToMainView$ = PublishSubject<BappyTabBarViewModel?>()
    
    private let firbaseSignInState$: BehaviorSubject<Bool>
    private let isAnonymousUser$: BehaviorSubject<Bool>

    private let showAlert$ = PublishSubject<Alert?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let firbaseSignInState$ = dependency.firebaseRepository.isUserSignedIn
        let isAnonymousUser$ = dependency.firebaseRepository.isAnonymous
        
        let switchToSignInView = switchToSignInView$
            .asSignal(onErrorJustReturn: nil)
        let switchToMainView = switchToMainView$
            .asSignal(onErrorJustReturn: nil)
        let showAlert = showAlert$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            switchToSignInView: switchToSignInView,
            switchToMainView: switchToMainView,
            showAlert: showAlert
        )
        
        // MARK: Bindind
        self.firbaseSignInState$ = firbaseSignInState$
        self.isAnonymousUser$ = isAnonymousUser$
        
        let remoteConfigValuesResult = dependency.firebaseRepository.getRemoteConfigValues()
            .share()
        
        remoteConfigValuesResult
            .compactMap(getRemoteConfigValuesError)
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        let remoteConfigValues = remoteConfigValuesResult
            .compactMap(getRemoteConfigValues)
            .share()
        
        // 앱 버전이 최소 버전 보다 작은 경우
        remoteConfigValues
            .filter { !checkCurrentVersion(with: $0.minimumVersion) }
            .map { _ -> Alert in
                let appleID = "" // 나중에 AppStore Connect에서 확인
                let urlStr = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
                let url = URL(string: urlStr)
                let title = "This version is not supported"
                let message = "Please update \"Bappy\" to the latest version"
                let actionTitle = "Go to update"
                
                let action = Alert.Action(
                    actionTitle: actionTitle,
                    actionStyle: .disclosure) {
                        if let url = url {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            // 강제종료
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
                        }
                    }
                
                return Alert(
                    title: title,
                    message: message,
                    bappyStyle: .happy,
                    canDismissByTouch: false,
                    action: action
                    )
            }
            .bind(to: showAlert$)
            .disposed(by: disposeBag)
        
        let notice = remoteConfigValues
            .filter { checkCurrentVersion(with: $0.minimumVersion) }
            .map(\.notice)
            .share()
        
        // 공지사항이 있는 경우
        notice
            .filter(\.hasNotice)
            .map { notice -> Alert in
                return Alert(
                    title: notice.noticeTitle,
                    message: notice.noticeMessage,
                    bappyStyle: .happy,
                    canDismissByTouch: false)
            }
            .bind(to: showAlert$)
            .disposed(by: disposeBag)
        
        let startFlow = notice
            .filter { !$0.hasNotice }
            .map { _ in }
            .share()
        
        // Not Sign In
        startFlow
            .withLatestFrom(firbaseSignInState$)
            .filter { !$0 }
            .map { _ -> BappyLoginViewModel in
                print("DEBUG: Not Signed In")
                let dependency = BappyLoginViewModel.Dependency(
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: dependency.firebaseRepository)
                return BappyLoginViewModel(dependency: dependency)
            }
            .bind(to: switchToSignInView$)
            .disposed(by: disposeBag)
        
    
        // Check Guest Mode
        startFlow
            .withLatestFrom(isAnonymousUser$)
            .filter { $0 }
            .map { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchAnonymousUser)
            .map { user -> BappyTabBarViewModel in
                print("DEBUG: Sign In Guest Mode")
                let dependency = BappyTabBarViewModel.Dependency(
                    selectedIndex: 0,
                    user: user,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return BappyTabBarViewModel(dependency: dependency)
            }
            .bind(to: switchToMainView$)
            .disposed(by: disposeBag)
    
        // Check registerd Firebase, but not in Backend
        let tokenResult = startFlow
            .withLatestFrom(
                Observable
                .combineLatest(firbaseSignInState$, isAnonymousUser$)
            )
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
            .compactMap(getToken)
            .map { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchCurrentUser)
            .observe(on: MainScheduler.asyncInstance)
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
                    bappyAuthRepository: dependency.bappyAuthRepository,
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
                    user: user,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return BappyTabBarViewModel(dependency: dependecy)
            }
            .bind(to: switchToMainView$)
            .disposed(by: disposeBag)
        
    }
}

private func getRemoteConfigValues(_ result: Result<RemoteConfigValues, Error>) -> RemoteConfigValues? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getRemoteConfigValuesError(_ result: Result<RemoteConfigValues, Error>) -> String? {
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

private func checkCurrentVersion(with minimumVersion: String) -> Bool {
    let dict = Bundle.main.infoDictionary!
    let currentVersion = dict["CFBundleShortVersionString"] as! String
    return minimumVersion.compare(currentVersion, options: .numeric) != .orderedDescending
}
