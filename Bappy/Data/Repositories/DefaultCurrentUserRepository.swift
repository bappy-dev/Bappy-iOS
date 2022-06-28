//
//  DefaultCurrentUserRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultCurrentUserRepository {
    
    private let provider: Provider = BappyProvider()
    private let currentUser$ = BehaviorSubject<BappyUser?>(value: nil)
    
    private init() {}
}

extension DefaultCurrentUserRepository: CurrentUserRepository {
    
    static let shared = DefaultCurrentUserRepository()
    var currentUser: BehaviorSubject<BappyUser?> { currentUser$ }
    
    func fetchCurrentUser(token: String) -> Single<Result<BappyUser, Error>> {
        let endpoint = APIEndpoints.getCurrentUser(token: token)
        return  provider.request(with: endpoint)
            .map { [weak self] result -> Result<BappyUser, Error> in
                switch result {
                case .success(let responseDTO):
                    let user = responseDTO.toDomain()
                    self?.currentUser$.onNext(user)
                    return .success(user)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
