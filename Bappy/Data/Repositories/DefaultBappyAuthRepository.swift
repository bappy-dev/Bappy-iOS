//
//  DefaultBappyAuthRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultBappyAuthRepository {
    
    private let provider: Provider = BappyProvider()
    private let currentUser$ = BehaviorSubject<BappyUser?>(value: nil)
    
    private init() {}
}

extension DefaultBappyAuthRepository: BappyAuthRepository {
    
    static let shared = DefaultBappyAuthRepository()
    var currentUser: BehaviorSubject<BappyUser?> { currentUser$ }
    
    func fetchCurrentUser(token: String) -> Single<Result<BappyUser, Error>> {
//        let endpoint = APIEndpoints.getCurrentUser(token: token)
//        return  provider.request(with: endpoint)
//            .map { [weak self] result -> Result<BappyUser, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    let user = responseDTO.toDomain()
//                    self?.currentUser$.onNext(user)
//                    return .success(user)
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        return Single<Result<BappyUser, Error>>.create { single in
            let user = BappyUser(id: UUID().uuidString, state: .notRegistered)
            self.currentUser$.onNext(user)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(user)))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchAnonymousUser() -> Single<BappyUser> {
        return Single<BappyUser>.create { single in
            let user = BappyUser(id: UUID().uuidString, state: .anonymous)
            self.currentUser$.onNext(user)
            single(.success(user))
            return Disposables.create()
        }
    }
    
    func createUser(name: String, gender: String, birth: Date, country: String) -> Single<Result<BappyUser, Error>> {
//        let requestDTO = CreateUserRequestDTO(
//            userName: name,
//            userGender: gender,
//            userBirth: birth,
//            userNationality: country
//        )
//        let endpoint = APIEndpoints.createUser(with: requestDTO, token: token)
//        return  provider.request(with: endpoint)
//            .map { [weak self] result -> Result<BappyUser, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    let user = responseDTO.toDomain()
//                    self?.currentUser$.onNext(user)
//                    return .success(user)
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        let country = country.split(separator: "/").map { String($0) }
        return Single<Result<BappyUser, Error>>.create { single in
            let user = BappyUser(
                id: UUID().uuidString,
                state: .normal,
                name: name,
                gender: Gender(rawValue: gender) ?? .Other,
                birth: birth,
                nationality: Country(code: country[1], name: country[0])
                )
            self.currentUser$.onNext(user)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(user)))
            }
            
            return Disposables.create()
        }
    }
}
