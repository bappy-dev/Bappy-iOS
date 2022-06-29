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
    
    func fetchUserProfile(id: String, token: String) -> Single<Result<Profile, Error>> {
        let requestDTO = UserProfileRequestDTO(id: id)
        let endpoint = APIEndpoints.getUserProfile(with: requestDTO, token: token)
        return  provider.request(with: endpoint)
            .map { result -> Result<Profile, Error> in
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
