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
        var registerDependency: RegisterViewModel.Dependency {
            let yearList = Array(1931...Date.thisYear-17)
                .map { String($0) }
            let monthList = Array(1...12)
                .map { String($0) }
                .map { ($0.count == 1) ? "0\($0)" : $0 }
            let dayList = Array(1...31)
                .map { String($0) }
                .map { ($0.count == 1) ? "0\($0)" : $0 }
            let country = Country(code: "KR", name: "South Korea")
            let countries = NSLocale.isoCountryCodes
                .map { NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]) }
                .map { countryCode -> Country in
                    let code = String(countryCode[countryCode.index(after: countryCode.startIndex)...])
                    let name = NSLocale(localeIdentifier: "en_UK")
                        .displayName(forKey: NSLocale.Key.identifier, value: countryCode) ?? ""
                    return Country(code: code, name: name)
                }
            let bappyAuthRepository = bappyAuthRepository
            let firebaseRepository = firebaseRepository
            
            return RegisterViewModel.Dependency(
                bappyAuthRepository: bappyAuthRepository,
                firebaseRepository: firebaseRepository,
                numOfPage: 4,
                isButtonEnabled: false,
                nameDependency: .init(
                    minimumLength: 3,
                    maximumLength: 30),
                birthDependency: .init(
                    year: "2000",
                    month: "06",
                    day: "15",
                    yearList: yearList,
                    monthList: monthList,
                    dayList: dayList),
                country: country,
                selectnationalityDependency: .init(
                    country: country,
                    countries: countries)
            )
        }
    }
    
    struct Input {
        var googleCredential: AnyObserver<AuthCredential> // <-> View
        var facebookCredential: AnyObserver<AuthCredential> // <-> View
        var appleCredential: AnyObserver<AuthCredential> // <-> View
        var skipButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var showLoader: Signal<Bool> // <-> View
        var signIn: PublishSubject<BappyTabBarViewModel> // <-> View
        var showRegisterView: PublishSubject<RegisterViewModel> // <-> View
        
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let showLoader$ = PublishSubject<Bool>()
    private let signIn$ = PublishSubject<BappyTabBarViewModel>()
    private let showRegisterView$ = PublishSubject<RegisterViewModel>()
    
    private let googleCredential$ = PublishSubject<AuthCredential>()
    private let facebookCredential$ = PublishSubject<AuthCredential>()
    private let appleCredential$ = PublishSubject<AuthCredential>()
    private let skipButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let showLoader = showLoader$
            .asSignal(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            googleCredential: googleCredential$.asObserver(),
            facebookCredential: facebookCredential$.asObserver(),
            appleCredential: appleCredential$.asObserver(),
            skipButtonTapped: skipButtonTapped$.asObserver()
        )
        
        self.output = Output(
            showLoader: showLoader,
            signIn: signIn$,
            showRegisterView: showRegisterView$
        )
        
        // Bindind
        let signInResult = Observable
            .merge(googleCredential$, facebookCredential$, appleCredential$)
            .do { _ in self.showLoader$.onNext(true) }
            .flatMap(dependency.firebaseRepository.signIn)
            .share()
        
        signInResult
            .compactMap(getAuthError)
            .do { _ in self.showLoader$.onNext(false) }
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        let tokenResult = signInResult
            .map(getAuthResult)
            .compactMap { _ in }
            .flatMap(dependency.firebaseRepository.getIDTokenForcingRefresh)
            .share()
        
        tokenResult
            .compactMap(getTokenError)
            .do { _ in self.showLoader$.onNext(false) }
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        let signInUserResult = tokenResult
            .compactMap(getToken)
            .flatMap(dependency.bappyAuthRepository.fetchCurrentUser)
            .observe(on: MainScheduler.asyncInstance)
            .do { _ in self.showLoader$.onNext(false) }
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
                return RegisterViewModel(dependency: dependency.registerDependency)
            }
            .bind(to: showRegisterView$)
            .disposed(by: disposeBag)
        
        let anonymousResult = skipButtonTapped$
            .do { _ in self.showLoader$.onNext(true) }
            .flatMap(dependency.firebaseRepository.signInAnonymously)
            .do { _ in self.showLoader$.onNext(false) }
            .share()
        
        let anonymousUser = anonymousResult
            .map(getAuthResult)
            .compactMap { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchAnonymousUser)
        
        anonymousResult
            .map(getAuthError)
            .compactMap { $0 }
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        Observable.merge(signInNormalUser, anonymousUser)
            .map { user -> BappyTabBarViewModel in
                let dependecy = BappyTabBarViewModel.Dependency(
                    selectedIndex: 0,
                    user: user,
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: dependency.firebaseRepository
                )
                return BappyTabBarViewModel(dependency: dependecy)
            }
            .bind(to: signIn$)
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
