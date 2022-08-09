//
//  DefaultBappyAuthRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultBappyAuthRepository {
    
    private let disposeBag = DisposeBag()
    private let provider: Provider = BappyProvider()
    private let currentUser$ = BehaviorSubject<BappyUser?>(value: nil)
    private let fcmToken$ = BehaviorSubject<String?>(value: nil)
    
    private init() {
        // 로그인시 fcmToken 서버에 백그라운드 업로드
        currentUser$
            .compactMap { $0 }
            .take(1)
            .withLatestFrom(fcmToken$.compactMap { $0 })
            .bind(onNext: updateFCMToken)
            .disposed(by: disposeBag)
    }
    
    private func updateFCMToken(_ fcmToken: String) {
        let requestDTO = UpdateFCMTokenRequestDTO(fcmToken: fcmToken)
        let endpoint = APIEndpoints.updateFCMToken(with: requestDTO)
        provider.request(with: endpoint) { _ in }
    }
}

extension DefaultBappyAuthRepository: BappyAuthRepository {
    
    static let shared = DefaultBappyAuthRepository()
    var currentUser: BehaviorSubject<BappyUser?> { currentUser$ }
    
    func fetchCurrentUser() -> Single<Result<BappyUser, Error>> {
//        let endpoint = APIEndpoints.fetchCurrentUser()
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
        
        // Sample Data
        return Single<Result<BappyUser, Error>>.create { single in
            let user = BappyUser(
                id: "abc",
                state: .normal,
                isUserUsingGPS: false,
                name: "David",
                gender: .Male,
                birth: Date(),
                nationality: Country(code: "KR"),
                profileImageURL: URL(string: EXAMPLE_IMAGE3_URL),
                introduce: "Hello ~~",
                affiliation: "Bappy",
                languages: ["Korean", "English"],
                personalities: [.Empathatic, .Talkative, .Spontaneous],
                interests: [.Culture, .Travel, .Language]
            )
            self.currentUser$.onNext(user)

            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(user)))
            }

            return Disposables.create()
        }
    }
    
    func fetchAnonymousUser() -> Single<BappyUser> {
        return Single<BappyUser>.create { single in
            let user = BappyUser(id: UUID().uuidString, state: .anonymous, isUserUsingGPS: false)
            self.currentUser$.onNext(user)
            single(.success(user))
            return Disposables.create()
        }
    }
    
    func createUser(name: String, gender: Gender, birth: Date, countryCode: String) -> Single<Result<BappyUser, Error>> {
//        var userGender: String {
//            switch gender {
//            case .Male: return "0"
//            case .Female: return "1"
//            case .Other: return "2" }
//        }
//
//        let requestDTO = CreateUserRequestDTO(
//            userName: name,
//            userGender: userGender,
//            userBirth: birth.toString(dateFormat: "yyyy.MM.dd"),
//            userNationality: countryCode
//        )
//
//        let endpoint = APIEndpoints.createUser(with: requestDTO)
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
        
        // Sample Data
        return Single<Result<BappyUser, Error>>.create { single in
            let user = BappyUser(
                id: UUID().uuidString,
                state: .normal,
                name: name,
                gender: Gender(rawValue: gender.rawValue) ?? .Other,
                birth: birth,
                nationality: Country(code: countryCode))
            self.currentUser$.onNext(user)

            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(user)))
            }

            return Disposables.create()
        }
    }
    
    func deleteUser() -> Single<Result<Bool, Error>> {
        let endpoint = APIEndpoints.deleteUser()
        return  provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func updateProfile(affiliation: String?,
                       introduce: String?,
                       languages: [Language]?,
                       personalities: [Persnoality]?,
                       interests: [Hangout.Category]?,
                       data: Data?) -> Single<Result<Bool, Error>> {
        let languages = languages
            .map { $0.joined(separator: ",") }
        let interests = interests
            .map { $0.map(\.description).joined(separator: ",") }
        let personalities = personalities
            .map { $0.map(\.rawValue).joined(separator: ",") }
        let requestDTO = UpdateProfileRequestDTO(
            userAffiliation: affiliation,
            userIntroduce: introduce,
            userLanguages: languages,
            userInterests: interests,
            userPersonalities: personalities)
        let endpoint = APIEndpoints.updateProfile(with: requestDTO, data: data)
        return  provider.request(with: endpoint)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success(let responseDTO):
                    let user = responseDTO.toDomain()
                    return .success(user)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func updateGPSSetting(to setting: Bool) -> Single<Result<Bool, Error>> {
//        let requestDTO = UpdateGPSSettingRequestDTO(gps: setting)
//        let endpoint = APIEndpoints.updateGPSSetting(with: requestDTO)
//        return  provider.request(with: endpoint)
//            .map { [weak self] result -> Result<Bool, Error> in
//                guard let self = self,
//                      var user = try self.currentUser.value()
//                else { return .failure(NetworkError.emptyUser) }
//                switch result {
//                case .success(let responseDTO):
//                    let isSucceeded = responseDTO.toDomain()
//                    user.isUserUsingGPS = setting
//                    self.currentUser.onNext(user)
//                    return .success(isSucceeded)
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<Bool, Error>>.create { single in
            do {
                guard var user = try self.currentUser.value()
                else { return Disposables.create() }
                user.isUserUsingGPS = setting
                self.currentUser$.onNext(user)

                DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                    single(.success(.success(true)))
                }

            } catch {
                single(.failure(NetworkError.emptyUser))
            }

            return Disposables.create()
        }
    }
    
    func registerFCMToken(_ fcmToken: String) {
        self.fcmToken$.onNext(fcmToken)
    }
    
    func fetchLocations() -> Single<Result<[Location], Error>> {
//        let endpoint = APIEndpoints.fetchLocations()
//        return  provider.request(with: endpoint)
//            .map { result -> Result<[Location], Error> in
//                switch result {
//                case .success(let responseDTO):
//                    return .success(responseDTO.toDomain())
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<[Location], Error>>.create { single in
            let locations = [
                Location(
                    identity: UUID().uuidString,
                    name: "Centum Station",
                    address: "210 Haeun-daero, Haeundae-gu, Busan, South Korea",
                    coordinates: Coordinates(latitude: 35.179495, longitude: 129.124544),
                    isSelected: false
                ),
                Location(
                    identity: UUID().uuidString,
                    name: "Pusan National University",
                    address: "2 Busandaehak-ro 63beon-gil, Geumjeong-gu, Busan, South Korea",
                    coordinates: Coordinates(latitude: 35.2339681, longitude: 129.0806855),
                    isSelected: false
                ),
                Location(
                    identity: UUID().uuidString,
                    name: "Dongseong-ro",
                    address: "Dongseong-ro, Jung-gu, Daegu, South Korea",
                    coordinates: Coordinates(latitude: 35.8715163, longitude: 128.5959431),
                    isSelected: false
                ),
                Location(
                    identity: UUID().uuidString,
                    name: "Pangyo-dong",
                    address: "Pangyo-dong, Bundang-gu, Seongnam-si, Gyeonggi-do, South Korea",
                    coordinates: Coordinates(latitude: 37.3908894, longitude: 127.0967915),
                    isSelected: false
                ),
            ]

            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(locations)))
            }

            return Disposables.create()
        }
    }
    
    func createLocation(location: Location) -> Single<Result<Bool, Error>> {
//        let requestDTO = CreateLocationRequestDTO(
//            locationID: location.identity,
//            locationName: location.name,
//            locationAddress: location.address,
//            latitude: location.coordinates.latitude,
//            longitude: location.coordinates.longitude,
//            isSelected: location.isSelected)
//        let endpoint = APIEndpoints.createLocation(with: requestDTO)
//        return  provider.request(with: endpoint)
//            .map { result -> Result<Bool, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    return .success(responseDTO.toDomain())
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<Bool, Error>>.create { single in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(true)))
            }

            return Disposables.create()
        }
    }
    
    func deleteLocation(id: String) -> Single<Result<Bool, Error>> {
//        let requestDTO = DeleteLocationRequestDTO(locationID: id)
//        let endpoint = APIEndpoints.deleteLocation(with: requestDTO)
//        return  provider.request(with: endpoint)
//            .map { result -> Result<Bool, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    return .success(responseDTO.toDomain())
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<Bool, Error>>.create { single in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(true)))
            }

            return Disposables.create()
        }
    }
    
    func selectLocation(id: String, isSelected: Bool) -> Single<Result<Bool, Error>> {
//        let requestDTO = SelectLocationRequestDTO(locationID: id, isSelected: isSelected)
//        let endpoint = APIEndpoints.selectLocation(with: requestDTO)
//        return  provider.request(with: endpoint)
//            .map { [weak self] result -> Result<Bool, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    if let self = self,
//                       var user = try self.currentUser$.value(),
//                        isSelected {
//                        user.isUserUsingGPS = false
//                        self.currentUser$.onNext(user)
//                    }
//                    return .success(responseDTO.toDomain())
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<Bool, Error>>.create { [weak self] single in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                if let self = self,
                   var user = try! self.currentUser$.value(),
                    isSelected {
                    user.isUserUsingGPS = false
                    self.currentUser$.onNext(user)
                }

                single(.success(.success(true)))
            }

            return Disposables.create()
        }
    }
    
    func fetchNotificationSetting() -> Single<Result<NotificationSetting, Error>> {
//        let endpoint = APIEndpoints.fetchNotificationSetting()
//        return  provider.request(with: endpoint)
//            .map { result -> Result<NotificationSetting, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    return .success(responseDTO.toDomain())
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<NotificationSetting, Error>>.create { single in
            let notificationSetting = NotificationSetting(myHangout: true, newHangout: false)

            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(notificationSetting)))
            }

            return Disposables.create()
        }
    }
    
    func updateNotificationSetting(myHangout: Bool?, newHangout: Bool?) -> Single<Result<Bool, Error>> {
//        let requestDTO = UpdateNotificationSettingRequestDTO(myHangout: myHangout, newHangout: newHangout)
//        let endpoint = APIEndpoints.updateNotificationSetting(with: requestDTO)
//        return  provider.request(with: endpoint)
//            .map { result -> Result<Bool, Error> in
//                switch result {
//                case .success(let responseDTO):
//                    return .success(responseDTO.toDomain())
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
        
        // Sample Data
        return Single<Result<Bool, Error>>.create { single in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(true)))
            }

            return Disposables.create()
        }
    }
}
