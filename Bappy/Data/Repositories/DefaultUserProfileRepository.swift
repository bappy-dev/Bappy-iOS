//
//  DefaultUserProfileRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultUserProfileRepository {
    
    private let provider: Provider
    
    init(provider: Provider = BappyProvider()) {
        self.provider = provider
    }
}

extension DefaultUserProfileRepository: UserProfileRepository {
    func fetchUserProfile(id: String) -> Single<Result<BappyUser, Error>> {
        let endpoint = APIEndpoints.fetchUserProfile(with: id)
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
        
        // Sample Data
//        return Single<Result<BappyUser, Error>>.create { single in
//            let user = BappyUser(
//                id: "abc",
//                state: .normal,
//                name: "Bappy",
//                gender: .Other,
//                birth: Date(),
//                nationality: Country(code: "KR"),
//                profileImageURL: nil,
//                introduce: "Nice to meet you",
//                affiliation: "Metaverse",
//                languages: ["Korean", "English"],
//                personalities: [.Empathatic, .Talkative],
//                interests: [.Cook, .Crafting],
//                numOfJoinedHangouts: 3,
//                numOfMadeHangouts: 5,
//                numOfLikedHangouts: 10)
//
//            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
//                single(.success(.success(user)))
//            }
//
//            return Disposables.create()
//        }
    }
}
