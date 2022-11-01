//
//  DefaultHangoutRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultHangoutRepository {
    
    private let provider: Provider
    
    init(provider: Provider = BappyProvider()) {
        self.provider = provider
    }
}

extension DefaultHangoutRepository: HangoutRepository {
    func filterHangouts(week: [Weekday], language: [String], hangoutCategory: [Hangout.Category], startDate: Date, endDate: Date?) -> Single<Result<HangoutPage, Error>> {
        var endDateToUse = endDate
        if endDateToUse == nil {
            endDateToUse = startDate
        }
        
        let requestDTO = FilterHangoutRequestDTO(week: week.map { $0.rawValue }, language: language, hangoutCategory: hangoutCategory.map { $0.description }, startDate: startDate.toString(dateFormat: "yyyy-MM-dd"), endDate: endDateToUse!.toString(dateFormat: "yyyy-MM-dd"))
        let endpoint = APIEndpoints.filterHangouts(with: requestDTO)
        
        return provider.request(with: endpoint)
            .map { result -> Result<HangoutPage, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchHangouts(page: Int, sort: Hangout.SortingOrder, categorey: Hangout.Category) -> Single<Result<HangoutPage, Error>> {
        let requestDTO = FetchHangoutsRequestDTO(hangoutSort: sort.description,
                                                 hangoutCategory: categorey.description)
        let endpoint = APIEndpoints.fetchHangouts(with: requestDTO, page: page)
        
        return provider.request(with: endpoint)
            .map { result -> Result<HangoutPage, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    //    func fetchHangouts(page: Int, sorting: Hangout.SortingOrder, category: Hangout.Category, coordinates: Coordinates?) -> Single<Result<HangoutPage, Error>> {
    //        let coordinates = coordinates.flatMap { "\($0.latitude),\($0.longitude)" }
    //        let requestDTO = FetchHangoutsRequestDTO(
    //            page: page,
    //            sorting: sorting.description,
    //            category: category.description,
    //            coordinates: coordinates)
    //        let endpoint = APIEndpoints.fetchHangouts(with: requestDTO)
    //        return  provider.request(with: endpoint)
    //            .map { result -> Result<HangoutPage, Error> in
    //                switch result {
    //                case .success(let responseDTO):
    //                    let hangout = HangoutPage(totalPage: responseDTO.data.pageInfo.totalCount, hangouts: responseDTO.data.toDomain())
    //                    return .success(hangout)
    //                case .failure(let error):
    //                    return .failure(error)
    //                }
    //            }
    
    // Sample Data
    //        return Single<Result<HangoutPage, Error>>.create { single in
    //            let hangouts: [Hangout] = [
    //                Hangout(
    //                    id: "abc", state: .available, title: "Who wants to go eat?",
    //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "abc", imageURL: nil),
    //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                    ],
    //                    userHasLiked: true),
    //                Hangout(
    //                    id: "def", state: .available, title: "Who wants to go eat?",
    //                    meetTime: "03. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "def", imageURL: nil),
    //                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                    ],
    //                    userHasLiked: false),
    //                Hangout(
    //                    id: "def", state: .closed, title: "Who wants to go eat?",
    //                    meetTime: "02. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "abc", imageURL: nil),
    //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
    //                    ],
    //                    userHasLiked: false),
    //                Hangout(
    //                    id: "abc", state: .expired, title: "Who wants to go eat?",
    //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "abc", imageURL: nil),
    //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                    ],
    //                    userHasLiked: true),
    //            ]
    //            var hangoutList = hangouts + hangouts
    //            hangoutList.shuffle()
    //            let totalPage = 3
    //            let hangoutPage = HangoutPage(totalPage: totalPage, hangouts: hangoutList)
    //
    //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
    //                single(.success(.success(hangoutPage)))
    //            }
    //
    //            return Disposables.create()
    //        }
    //    }
    
    func fetchHangouts(profileType: Hangout.UserProfileType, id: String?) -> Single<Result<[Hangout], Error>> {
        let requestDTO = FetchHangoutsOfUserRequestDTO(filter: profileType.description)
        
        let endpoint = APIEndpoints.fetchHangouts(with: requestDTO, id: id)
        
        return provider.request(with: endpoint)
            .map { result -> Result<[Hangout], Error> in
                switch result {
                case .success(let responseDTO):
                    print("얍", responseDTO.toDomain())
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchHangout(hangoutID: String) -> Single<Result<Hangout, Error>> {
        let endpoint = APIEndpoints.fetchHangout(with: hangoutID)
        
        return provider.request(with: endpoint)
            .map { result -> Result<Hangout, Error> in
                switch result {
                case .success(let responseDTO):
                    print("얍", responseDTO.toDomain())
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    // Sample Data
    //        return Single<Result<[Hangout], Error>>.create { single in
    //            let joinedHangouts: [Hangout] = [
    //                Hangout(
    //                    id: "abc", state: .available, title: "Who wants to go eat?",
    //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "abc", imageURL: nil),
    //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                    ],
    //                    userHasLiked: true),
    //                Hangout(
    //                    id: "def", state: .available, title: "Who wants to go eat?",
    //                    meetTime: "03. JUL. 15:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "def", imageURL: nil),
    //                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                    ],
    //                    userHasLiked: false),
    //                Hangout(
    //                    id: "def", state: .closed, title: "Who wants to go eat?",
    //                    meetTime: "02. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
    //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                    placeName: "Pusan University",
    //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                    postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
    //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                    participantIDs: [
    //                        .init(id: "abc", imageURL: nil),
    //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
    //                    ],
    //                    userHasLiked: false),
    //                ]
    //                let madeHangouts: [Hangout] = []
    //                let likedHangouts: [Hangout] = [
    //                    Hangout(
    //                        id: "abc", state: .available, title: "Who wants to go eat?",
    //                        meetTime: "01. JUL. 11:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
    //                        placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                        placeName: "Pusan University",
    //                        plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                        limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                        postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
    //                        openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                        mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                        participantIDs: [
    //                            .init(id: "abc", imageURL: nil),
    //                            .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                        ],
    //                        userHasLiked: true),
    //                    Hangout(
    //                        id: "def", state: .available, title: "Who wants to go eat?",
    //                        meetTime: "03. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
    //                        placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
    //                        placeName: "Pusan University",
    //                        plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
    //                        limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
    //                        postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
    //                        openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
    //                        mapImageURL: URL(string: EXAMPLE_MAP_URL),
    //                        participantIDs: [
    //                            .init(id: "def", imageURL: nil),
    //                            .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
    //                        ],
    //                        userHasLiked: false),
    //            ]
    //
    //            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
    //                switch profileType {
    //                case .Joined: single(.success(.success(joinedHangouts)))
    //                case .Made: single(.success(.success(madeHangouts)))
    //                case .Liked: single(.success(.success(likedHangouts))) }
    //            }
    //
    //            return Disposables.create()
    //        }
    //    }
    
    func createHangout(hangout: Hangout, imageData: Data) -> Single<Result<Bool, Error>> {
        let requestDTO = CreateHangoutRequestDTO(hangoutTitle: hangout.title,
                                                 hangoutPlan: hangout.plan,
                                                 hangoutLanguage: hangout.language,
                                                 hangoutTotalNum: hangout.limitNumber,
                                                 hangoutOpenChat: hangout.openchatURL.absoluteString,
                                                 hangoutCategory: hangout.categories.map { $0.description },
                                                 placeLatitude: "\(hangout.place.coordinates.latitude)",
                                                 placeLongitude: "\(hangout.place.coordinates.longitude)",
                                                 placeAddress: hangout.place.address,
                                                 hangoutMeetTime: hangout.meetTime.toString(dateFormat: "yyyy-MM-dd HH:mm"),
                                                 placeName: hangout.place.name)
        
        let endpoint = APIEndpoints.createHangout(with: requestDTO, data: imageData)
        
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
        
        // Sample Data
        //        return Single<Result<Bool, Error>>.create { single in
        //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
        //                single(.success(.success(true)))
        //            }
        //            return Disposables.create()
        //        }
    }
    
    func deleteHangout(hangoutID: String) -> Single<Result<Bool, Error>> {
        let endpoint = APIEndpoints.deleteHangout(hangoutID: hangoutID)
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func likeHangout(hangoutID: String, hasUserLiked: Bool) -> Single<Result<Bool, Error>> {
        let endpoint = APIEndpoints.likeHangout(hangoutID: hangoutID, hasUserLiked: hasUserLiked)
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
        
        // Sample Data
        //        return Single<Result<Bool, Error>>.create { single in
        //            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
        //                single(.success(.success(true)))
        //            }
        //            return Disposables.create()
        //        }
    }
    
    func joinHangout(hangoutID: String) -> Single<Result<Bool, Error>> {
        let requestDTO = UpdateHangoutParticipationRequestDTO(action: "join")
        let endpoint = APIEndpoints.updateHangoutParticipation(with: requestDTO, hangoutID: hangoutID)
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.data)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func cancelHangout(hangoutID: String) -> Single<Result<Bool, Error>> {
        let requestDTO = UpdateHangoutParticipationRequestDTO(action: "cancel")
        let endpoint = APIEndpoints.updateHangoutParticipation(with: requestDTO, hangoutID: hangoutID)
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
//                    let bool = responseDTO.data as! Bool
                    return .success(responseDTO.data)
                case .failure(let error):
                    return .failure(error)
                }
            }
        
        // Sample Data
        //        return Single<Result<Bool, Error>>.create { single in
        //            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
        //                single(.success(.success(true)))
        //            }
        //            return Disposables.create()
        //        }
    }
    
    func reportHangout(hangoutID: String, reportType: String, detail: String, imageDatas: [Data]?) -> Single<Result<Bool, Error>> {
        let requestDTO = ReportHangoutRequestDTO(
            hangoutID: hangoutID,
            reportTitle: reportType,
            reportDetail: detail)
        let endpoint = APIEndpoints.reportHangout(with: requestDTO, datas: imageDatas)
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
        
        // Sample Data
        //        return Single<Result<Bool, Error>>.create { single in
        //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
        //                single(.success(.success(true)))
        //            }
        //            return Disposables.create()
        //        }
    }
    
    func makeReviews(referenceModels: [MakeReferenceModel], hangoutID: String) -> RxSwift.Single<Result<Bool, Error>> {
        let requestDTO = MakeReviewsRequestDTO(reviews: referenceModels.map {
            MakeReviewsRequestDTO.MakeReviewRequestDTO(
                tags: $0.tags,
                message: $0.message,
                receiveId: $0.targetID,
                hangoutInfoId: hangoutID)
        })
        let endpoint = APIEndpoints.makeReviews(with: requestDTO)
        return provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchReviews(id: String?) -> RxSwift.Single<Result<[Reference], Error>> {
        let endpoint = APIEndpoints.fetchReviews(id: id)
        
        return provider.request(with: endpoint)
            .map { result -> Result<[Reference], Error> in
                switch result {
                case .success(let responseDTO):
                    print("얍 \(id)", responseDTO.toDomain())
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func searchHangouts(title: String) -> Single<Result<HangoutPage, Error>> {
        let requestDTO = SearchHangoutsRequestDTO(title: title)
        let endpoint = APIEndpoints.searchHangouts(with: requestDTO)
        return  provider.request(with: endpoint)
            .map { result -> Result<HangoutPage, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
        
        // Sample Data
        //        return Single<Result<HangoutPage, Error>>.create { single in
        //            let hangouts: [Hangout] = [
        //                Hangout(
        //                    id: "abc", state: .available, title: "Who wants to go eat?",
        //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
        //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
        //                    placeName: "Pusan University",
        //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
        //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
        //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
        //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
        //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
        //                    participantIDs: [
        //                        .init(id: "abc", imageURL: nil),
        //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
        //                    ],
        //                    userHasLiked: true),
        //                Hangout(
        //                    id: "def", state: .available, title: "Who wants to go eat?",
        //                    meetTime: "03. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
        //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
        //                    placeName: "Pusan University",
        //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
        //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
        //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
        //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
        //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
        //                    participantIDs: [
        //                        .init(id: "def", imageURL: nil),
        //                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
        //                    ],
        //                    userHasLiked: false),
        //                Hangout(
        //                    id: "def", state: .closed, title: "Who wants to go eat?",
        //                    meetTime: "02. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
        //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
        //                    placeName: "Pusan University",
        //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
        //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
        //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
        //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
        //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
        //                    participantIDs: [
        //                        .init(id: "abc", imageURL: nil),
        //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
        //                    ],
        //                    userHasLiked: false),
        //                Hangout(
        //                    id: "abc", state: .expired, title: "Who wants to go eat?",
        //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
        //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
        //                    placeName: "Pusan University",
        //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
        //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
        //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
        //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
        //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
        //                    participantIDs: [
        //                        .init(id: "abc", imageURL: nil),
        //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
        //                    ],
        //                    userHasLiked: true),
        //            ]
        //            var hangoutList = hangouts + hangouts
        //            hangoutList.shuffle()
        //            let totalPage = 3
        //            let hangoutPage = HangoutPage(totalPage: totalPage, hangouts: hangoutList)
        //
        //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
        //                single(.success(.success(hangoutPage)))
        //            }
        //
        //            return Disposables.create()
        //        }
    }
}

/*
 //
 //  DefaultHangoutRepository.swift
 //  Bappy
 //
 //  Created by 정동천 on 2022/07/06.
 //
 
 import Foundation
 import RxSwift
 import RxCocoa
 
 final class DefaultHangoutRepository {
 
 private let provider: Provider
 
 init(provider: Provider = BappyProvider()) {
 self.provider = provider
 }
 }
 
 extension DefaultHangoutRepository: HangoutRepository {
 func fetchHangouts(page: Int, sorting: Hangout.SortingOrder, category: Hangout.Category, coordinates: Coordinates?) -> Single<Result<HangoutPage, Error>> {
 let coordinates = coordinates.flatMap { "\($0.latitude),\($0.longitude)" }
 let requestDTO = FetchHangoutsRequestDTO(
 page: page,
 sorting: sorting.description,
 category: category.description,
 coordinates: coordinates)
 let endpoint = APIEndpoints.fetchHangouts(with: requestDTO)
 return  provider.request(with: endpoint)
 .map { result -> Result<HangoutPage, Error> in
 switch result {
 case .success(let responseDTO):
 let hangout = HangoutPage(totalPage: responseDTO.data.pageInfo.totalCount, hangouts: responseDTO.data.toDomain())
 return .success(hangout)
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<HangoutPage, Error>>.create { single in
 //            let hangouts: [Hangout] = [
 //                Hangout(
 //                    id: "abc", state: .available, title: "Who wants to go eat?",
 //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: true),
 //                Hangout(
 //                    id: "def", state: .available, title: "Who wants to go eat?",
 //                    meetTime: "03. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "def", imageURL: nil),
 //                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: false),
 //                Hangout(
 //                    id: "def", state: .closed, title: "Who wants to go eat?",
 //                    meetTime: "02. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
 //                    ],
 //                    userHasLiked: false),
 //                Hangout(
 //                    id: "abc", state: .expired, title: "Who wants to go eat?",
 //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: true),
 //            ]
 //            var hangoutList = hangouts + hangouts
 //            hangoutList.shuffle()
 //            let totalPage = 3
 //            let hangoutPage = HangoutPage(totalPage: totalPage, hangouts: hangoutList)
 //
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
 //                single(.success(.success(hangoutPage)))
 //            }
 //
 //            return Disposables.create()
 //        }
 }
 
 func fetchHangouts(profileType: Hangout.UserProfileType) -> Single<Result<[Hangout], Error>> {
 let requestDTO = FetchHangoutsOfUserRequestDTO(filter: profileType.description)
 let endpoint = APIEndpoints.fetchHangouts(with: requestDTO)
 
 return provider.request(with: endpoint)
 .map { result -> Result<[Hangout], Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<[Hangout], Error>>.create { single in
 //            let joinedHangouts: [Hangout] = [
 //                Hangout(
 //                    id: "abc", state: .available, title: "Who wants to go eat?",
 //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: true),
 //                Hangout(
 //                    id: "def", state: .available, title: "Who wants to go eat?",
 //                    meetTime: "03. JUL. 15:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "def", imageURL: nil),
 //                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: false),
 //                Hangout(
 //                    id: "def", state: .closed, title: "Who wants to go eat?",
 //                    meetTime: "02. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
 //                    ],
 //                    userHasLiked: false),
 //                ]
 //                let madeHangouts: [Hangout] = []
 //                let likedHangouts: [Hangout] = [
 //                    Hangout(
 //                        id: "abc", state: .available, title: "Who wants to go eat?",
 //                        meetTime: "01. JUL. 11:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                        placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                        placeName: "Pusan University",
 //                        plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                        limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                        postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
 //                        openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                        mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                        participantIDs: [
 //                            .init(id: "abc", imageURL: nil),
 //                            .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                        ],
 //                        userHasLiked: true),
 //                    Hangout(
 //                        id: "def", state: .available, title: "Who wants to go eat?",
 //                        meetTime: "03. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
 //                        placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                        placeName: "Pusan University",
 //                        plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                        limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                        postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
 //                        openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                        mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                        participantIDs: [
 //                            .init(id: "def", imageURL: nil),
 //                            .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                        ],
 //                        userHasLiked: false),
 //            ]
 //
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
 //                switch profileType {
 //                case .Joined: single(.success(.success(joinedHangouts)))
 //                case .Made: single(.success(.success(madeHangouts)))
 //                case .Liked: single(.success(.success(likedHangouts))) }
 //            }
 //
 //            return Disposables.create()
 //        }
 }
 
 func createHangout(hangout: Hangout, imageData: Data) -> Single<Result<Bool, Error>> {
 let requestDTO = CreateHangoutRequestDTO(hangoutTitle: hangout.title, hangoutPlan: hangout.plan, hangoutLanguage: hangout.language, hangoutTotalNum: String(hangout.limitNumber), hangoutImageUrl: imageData.description, hangoutOpenChat: hangout.openchatURL!.absoluteString)
 let endpoint = APIEndpoints.createHangout(with: requestDTO, data: imageData)
 
 
 return provider.request(with: endpoint)
 .map { result -> Result<Bool, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<Bool, Error>>.create { single in
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
 //                single(.success(.success(true)))
 //            }
 //            return Disposables.create()
 //        }
 }
 
 func deleteHangout(hangoutID: String) -> Single<Result<Bool, Error>> {
 let endpoint = APIEndpoints.deleteHangout(hangoutID: hangoutID)
 return provider.request(with: endpoint)
 .map { result -> Result<Bool, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 }
 
 func likeHangout(hangoutID: String, hasUserLiked: Bool) -> Single<Result<Bool, Error>> {
 let endpoint = APIEndpoints.likeHangout(hangoutID: hangoutID, hasUserLiked: hasUserLiked)
 return provider.request(with: endpoint)
 .map { result -> Result<Bool, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<Bool, Error>>.create { single in
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
 //                single(.success(.success(true)))
 //            }
 //            return Disposables.create()
 //        }
 }
 
 func joinHangout(hangoutID: String) -> Single<Result<Bool, Error>> {
 let requestDTO = UpdateHangoutParticipationRequestDTO(action: "join")
 let endpoint = APIEndpoints.updateHangoutParticipation(with: requestDTO, hangoutID: hangoutID)
 return provider.request(with: endpoint)
 .map { result -> Result<Bool, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 }
 
 func cancelHangout(hangoutID: String) -> Single<Result<Bool, Error>> {
 let requestDTO = UpdateHangoutParticipationRequestDTO(action: "cancel")
 let endpoint = APIEndpoints.updateHangoutParticipation(with: requestDTO, hangoutID: hangoutID)
 return provider.request(with: endpoint)
 .map { result -> Result<Bool, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<Bool, Error>>.create { single in
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
 //                single(.success(.success(true)))
 //            }
 //            return Disposables.create()
 //        }
 }
 
 func reportHangout(hangoutID: String, reportType: String, detail: String, imageDatas: [Data]?) -> Single<Result<Bool, Error>> {
 let requestDTO = ReportHangoutRequestDTO(
 hangoutID: hangoutID,
 reportTitle: reportType,
 reportDetail: detail)
 let endpoint = APIEndpoints.reportHangout(with: requestDTO, datas: imageDatas)
 return provider.request(with: endpoint)
 .map { result -> Result<Bool, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<Bool, Error>>.create { single in
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
 //                single(.success(.success(true)))
 //            }
 //            return Disposables.create()
 //        }
 }
 
 func searchHangouts(query: String, page: Int) -> Single<Result<HangoutPage, Error>> {
 let requestDTO = SearchHangoutsRequestDTO(query: query, page: page)
 let endpoint = APIEndpoints.searchHangouts(with: requestDTO)
 return  provider.request(with: endpoint)
 .map { result -> Result<HangoutPage, Error> in
 switch result {
 case .success(let responseDTO):
 return .success(responseDTO.toDomain())
 case .failure(let error):
 return .failure(error)
 }
 }
 
 // Sample Data
 //        return Single<Result<HangoutPage, Error>>.create { single in
 //            let hangouts: [Hangout] = [
 //                Hangout(
 //                    id: "abc", state: .available, title: "Who wants to go eat?",
 //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: true),
 //                Hangout(
 //                    id: "def", state: .available, title: "Who wants to go eat?",
 //                    meetTime: "03. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "Korean",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "def", imageURL: nil),
 //                        .init(id: "def", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: false),
 //                Hangout(
 //                    id: "def", state: .closed, title: "Who wants to go eat?",
 //                    meetTime: "02. JUL. 18:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE3_URL))
 //                    ],
 //                    userHasLiked: false),
 //                Hangout(
 //                    id: "abc", state: .expired, title: "Who wants to go eat?",
 //                    meetTime: "01. JUL. 19:00".toDate(format: "dd. MMM. HH:mm")!, language: "English",
 //                    placeID: "ChIJddvJ8eqTaDURk21no4Umdvo",
 //                    placeName: "Pusan University",
 //                    plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
 //                    limitNumber: 5, coordinates: .init(latitude: 35.2342279, longitude: 129.0860221),
 //                    postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
 //                    openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
 //                    mapImageURL: URL(string: EXAMPLE_MAP_URL),
 //                    participantIDs: [
 //                        .init(id: "abc", imageURL: nil),
 //                        .init(id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
 //                    ],
 //                    userHasLiked: true),
 //            ]
 //            var hangoutList = hangouts + hangouts
 //            hangoutList.shuffle()
 //            let totalPage = 3
 //            let hangoutPage = HangoutPage(totalPage: totalPage, hangouts: hangoutList)
 //
 //            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
 //                single(.success(.success(hangoutPage)))
 //            }
 //
 //            return Disposables.create()
 //        }
 }
 }
 
 */
