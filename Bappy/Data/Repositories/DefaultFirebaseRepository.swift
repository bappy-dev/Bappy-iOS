//
//  DefaultFirebaseRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseRemoteConfig
import RxSwift

final class DefaultFirebaseRepository {
    private let auth: Auth
    private let remoteConfig: RemoteConfig
    private let user$: BehaviorSubject<User?>
    private let isUserSignedIn$: BehaviorSubject<Bool>
    private let isAnonymous$: BehaviorSubject<Bool>
    private let token$: BehaviorSubject<String?>
    
    private var disposeBag = DisposeBag()
    
    private init() {
        let auth = Auth.auth()
        let remoteConfig = RemoteConfig.remoteConfig()
        let user = auth.currentUser
        let user$ = BehaviorSubject<User?>(value: user)
        let isUserSignedIn$ = BehaviorSubject<Bool>(value: user != nil)
        let isAnonymous$ = BehaviorSubject<Bool>(value: user?.isAnonymous ?? false)
        let token$ = BehaviorSubject<String?>(value: nil)
        
        auth.addStateDidChangeListener { _, user in
            user$.onNext(user)
        }
        
        self.auth = auth
        self.remoteConfig = remoteConfig
        self.user$ = user$
        self.isUserSignedIn$ = isUserSignedIn$
        self.isAnonymous$ = isAnonymous$
        self.token$ = token$
        
        user$
            .map { $0 != nil }
            .bind(to: isUserSignedIn$)
            .disposed(by: disposeBag)
        
        user$
            .map { $0?.isAnonymous ?? false }
            .bind(to: isAnonymous$)
            .disposed(by: disposeBag)
        
        user$
            .filter { $0 == nil }
            .map { _ -> String? in return nil }
            .bind(to: token$)
            .disposed(by: disposeBag)
        
        setRemoteConfig()
    }
    
    private func setRemoteConfig() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        remoteConfig.setDefaults(fromPlist: "RemoteConfigValue")
    }
}

extension DefaultFirebaseRepository: FirebaseRepository {
    static let shared = DefaultFirebaseRepository()
    var isUserSignedIn: BehaviorSubject<Bool> { isUserSignedIn$ }
    var isAnonymous: BehaviorSubject<Bool> { isAnonymous$ }
    var token: BehaviorSubject<String?> { token$ }
    
    
    
    func getIDTokenForcingRefresh(completion: @escaping(Result<String?, Error>) -> Void) {
        auth.currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self?.token$.onNext(idToken)
            completion(.success(idToken))
        }
    }
    
    func getIDTokenForcingRefresh() -> Observable<Result<String?, Error>> {
        return user$
            .flatMap { user -> Observable<Result<String?, Error>> in
            return Observable<Result<String?, Error>>.create { observer in
                user?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
                    if let error = error {
                        observer.onNext(.failure(error))
                        return
                    }
                    self?.token$.onNext(idToken)
                    observer.onNext(.success(idToken))
                }
                return Disposables.create()
            }
        }
    }
    
    func signIn(with credential: AuthCredential) -> Single<Result<AuthDataResult?, Error>> {
        return Single<Result<AuthDataResult?, Error>>.create { [weak self] single in
            self?.auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                single(.success(.success(authResult)))
            }
            return Disposables.create()
        }
    }
    
    func signInAnonymously() -> Single<Result<AuthDataResult?, Error>> {
        return Single<Result<AuthDataResult?, Error>>.create { [weak self] single in
            self?.auth.signInAnonymously { authResult, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                single(.success(.success(authResult)))
            }
            return Disposables.create()
        }
    }
    
    func signOut() -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { [weak self] single in
            do {
                try self?.auth.signOut()
                single(.success(.success(Void())))
            } catch { single(.failure(FirebaseError.signOutFailed)) }
            return Disposables.create()
        }
    }
    
    func getRemoteConfigValues() -> Observable<Result<RemoteConfigValues, Error>> {
        return Observable<Result<RemoteConfigValues, Error>>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.remoteConfig.fetch { status, error in
                if status == .success {
                    self.remoteConfig.activate()
                    let minimumVersion = self.remoteConfig["minimumVersion"].stringValue!
                    
                    let hasNotice = self.remoteConfig["hasNotice"].boolValue
                    let noticeTitle = self.remoteConfig["noticeTitle"].stringValue!
                        .replacingOccurrences(of: "\\n", with: "\n")
                    let noticeMessage = self.remoteConfig["noticeMessage"].stringValue!
                        .replacingOccurrences(of: "\\n", with: "\n")
                    
                    let reasonsForReport = self.remoteConfig["reasonsForReport"].stringValue!
                        .replacingOccurrences(of: "\\n", with: "\n")
                        .split(separator: "\n")
                        .map(String.init)
                    let reasonsForWithdrawl = self.remoteConfig["reasonsForWithdrawl"].stringValue!
                        .replacingOccurrences(of: "\\n", with: "\n")
                        .split(separator: "\n")
                        .map(String.init)
                    
                    let remoteConfigValues = RemoteConfigValues(
                        notice: .init(
                            hasNotice: hasNotice,
                            noticeTitle: noticeTitle,
                            noticeMessage: noticeMessage),
                        minimumVersion: minimumVersion,
                        reasonsForReport: reasonsForReport,
                        reasonsForWithdrawl: reasonsForWithdrawl)
                    observer.onNext(.success(remoteConfigValues))
                } else {
                    observer.onError(FirebaseError.failedRemoteConfig)
                }
            }
            return Disposables.create()
        }
    }
}
