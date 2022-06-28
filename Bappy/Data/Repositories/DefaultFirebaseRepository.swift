//
//  DefaultFirebaseRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import UIKit
import FirebaseAuth
import RxSwift

final class DefaultFirebaseRepository {
    private let auth: Auth
    private let user$: BehaviorSubject<User?>
    private let isUserSignedIn$: BehaviorSubject<Bool>
    private let isAnonymous$: BehaviorSubject<Bool>
    private let token$: BehaviorSubject<String?>
    
    private var disposeBag = DisposeBag()
    
    private init() {
        let auth = Auth.auth()
        let user = auth.currentUser
        let user$ = BehaviorSubject<User?>(value: user)
        let isUserSignedIn$ = BehaviorSubject<Bool>(value: user != nil)
        let isAnonymous$ = BehaviorSubject<Bool>(value: user?.isAnonymous ?? false)
        let token$ = BehaviorSubject<String?>(value: nil)
        
        
        auth.addStateDidChangeListener { _, user in
            user$.onNext(user)
        }
        
        self.auth = auth
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
    }
}

extension DefaultFirebaseRepository: FirebaseRepository {
    
    static let shared = DefaultFirebaseRepository()
    var isUserSignedIn: BehaviorSubject<Bool> { isUserSignedIn$ }
    var isAnonymous: BehaviorSubject<Bool> { isAnonymous$ }
    var token: BehaviorSubject<String?> { token$ }
    
    func getIDTokenForcingRefresh() -> Single<Result<String?, Error>> {
        return user$
            .asSingle()
            .flatMap { user -> Single<Result<String?, Error>> in
            return Single<Result<String?, Error>>.create { single in
                user?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    self?.token$.onNext(idToken)
                    single(.success(.success(idToken)))
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
    
    func signOut() -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { [weak self] single in
            do {
                try self?.auth.signOut()
                single(.success(.success(Void())))
            } catch { single(.failure(FirebaseError.signOutFailed)) }
            return Disposables.create()
        }
    }
}
