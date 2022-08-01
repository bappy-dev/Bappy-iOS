//
//  DefaultHangoutRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultHangoutRepository {
    
    private let provider: Provider
    
    init(provider: Provider = BappyProvider()) {
        self.provider = provider
    }
}

extension DefaultHangoutRepository: HangoutRepository {
    
    func fetchHangouts(param: (sorting: String?, category: String?, coordinates: String?, token: String)) -> Single<Result<[Hangout], Error>> {
//        let requestDTO = HangoutsRequestDTO(sorting: nil, category: nil, coordinates: nil)
//        let endpoint = APIEndpoints.getHangouts(with: requestDTO, token: token)
//        return  provider.request(with: endpoint)
//            .map { result -> Result<Hangout, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    let user = responseDTO.toDomain()
//                    return .success(user)
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        return Single<Result<[Hangout], Error>>.create { single in
            let hangouts: [Hangout] = [
                Hangout(
                    id: "abc", state: .available, title: "Who wants to go eat?",
                    meetTime: "01. JUL. 19:00", language: "English",
                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
                    placeName: "Pusan University",
                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
                    participantIDs: [
                        .init(id: "abc", imageURL: nil),
                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
                    ],
                    userHasLiked: true),
                Hangout(
                    id: "def", state: .available, title: "Who wants to go eat?",
                    meetTime: "03. JUL. 18:00", language: "Korean",
                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
                    placeName: "Pusan University",
                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
                    participantIDs: [
                        .init(id: "def", imageURL: nil),
                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
                    ],
                    userHasLiked: false),
                Hangout(
                    id: "def", state: .closed, title: "Who wants to go eat?",
                    meetTime: "02. JUL. 18:00", language: "English",
                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
                    placeName: "Pusan University",
                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
                    participantIDs: [
                        .init(id: "abc", imageURL: nil),
                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
                    ],
                    userHasLiked: false),
                Hangout(
                    id: "abc", state: .expired, title: "Who wants to go eat?",
                    meetTime: "01. JUL. 19:00", language: "English",
                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
                    placeName: "Pusan University",
                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
                    participantIDs: [
                        .init(id: "abc", imageURL: nil),
                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
                    ],
                    userHasLiked: true),
            ]
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(hangouts)))
            }
            
            return Disposables.create()
        }
    }
}
