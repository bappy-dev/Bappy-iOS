//
//  DefaultUserProfileRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultUserProfileRepository {
    
    private let provider: Provider
    
    init(provider: Provider = BappyProvider()) {
        self.provider = provider
    }
}

extension DefaultUserProfileRepository: UserProfileRepository {
    
    func fetchBappyUser(id: String, token: String) -> Single<Result<BappyUser, Error>> {
        let requestDTO = BappyUserRequestDTO(id: id)
        let endpoint = APIEndpoints.getBappyUser(with: requestDTO)
        return  provider.request(with: endpoint)
            .map { result -> Result<BappyUser, Error> in
                switch result {
                case .success(let responseDTO):
                    let user = responseDTO.toDomain()
                    return .success(user)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
