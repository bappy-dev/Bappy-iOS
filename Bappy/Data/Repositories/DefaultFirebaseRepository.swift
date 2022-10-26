//
//  DefaultFirebaseRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseRemoteConfig
import RxSwift

final class DefaultFirebaseRepository {
    private let auth: Auth
    private let remoteConfig: RemoteConfig
    private let networkCheckRepository: NetworkCheckRepository
    
    private let user$: BehaviorSubject<User?>
    private let isUserSignedIn$: BehaviorSubject<Bool>
    private let isAnonymous$: BehaviorSubject<Bool>
    private let token$: BehaviorSubject<String?>
    
    private var disposeBag = DisposeBag()
    
    private init(networkCheckRepository: NetworkCheckRepository = DefaultNetworkCheckRepository.shared) {
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
        self.networkCheckRepository = networkCheckRepository
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
        networkCheckRepository.checkNetworkConnection { [weak self] in
            self?.auth.currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                self?.token$.onNext(idToken)
                completion(.success(idToken))
            }
        }
    }
    
    func getIDTokenForcingRefresh() -> Observable<Result<String?, Error>> {
        return Observable<Result<String?, Error>>.create { [weak self] observer in
            self?.getIDTokenForcingRefresh { result in
                observer.onNext(result)
            }
            return Disposables.create()
        }
    }
    
    func signIn(with credential: AuthCredential) -> Single<Result<AuthDataResult?, Error>> {
        return Single<Result<AuthDataResult?, Error>>.create { [weak self] single in
            self?.networkCheckRepository.checkNetworkConnection {
                self?.auth.signIn(with: credential) { authResult, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    single(.success(.success(authResult)))
                }
            }
            return Disposables.create()
        }
    }
    
    func signInAnonymously() -> Single<Result<AuthDataResult?, Error>> {
        return Single<Result<AuthDataResult?, Error>>.create { [weak self] single in
            self?.networkCheckRepository.checkNetworkConnection {
                self?.auth.signInAnonymously { authResult, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    single(.success(.success(authResult)))
                }
            }
            return Disposables.create()
        }
    }
    
    func signOut(completion: @escaping(Result<Void, Error>) -> Void) {
        networkCheckRepository.checkNetworkConnection { [weak self] in
            do {
                try self?.auth.signOut()
                completion(.success(Void()))
            } catch {
                completion(.failure(FirebaseError.signOutFailed))
            }
        }
    }
    
    func signOut() -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { [weak self] single in
            self?.signOut { result in
                switch result {
                case .success(let value):
                    single(.success(.success(value)))
                case .failure(let error):
                    single(.failure(error)) }
            }
            return Disposables.create()
        }
    }
    
    func deleteAccount(completion: @escaping(Result<Void, Error>) -> Void) {
        networkCheckRepository.checkNetworkConnection { [weak self] in
            self?.auth.currentUser?.delete() { error in
                print(error)
                if error == nil {
                    completion(.success(Void()))
                } else {
                    completion(.failure(FirebaseError.deleteFailed))
                }
            }
        }
    }
    
    func deleteAccount() -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { [weak self] single in
            self?.deleteAccount { result in
                switch result {
                case .success(let value):
                    single(.success(.success(value)))
                case .failure(let error):
                    single(.failure(error)) }
            }
            return Disposables.create()
        }
    }
    
    func getRemoteConfigValues() -> Observable<Result<RemoteConfigValues, Error>> {
        return Observable<Result<RemoteConfigValues, Error>>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.networkCheckRepository.checkNetworkConnection {
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
                        observer.onNext(.failure(FirebaseError.failedRemoteConfig))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
