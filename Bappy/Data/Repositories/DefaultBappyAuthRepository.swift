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
            let user = BappyUser(id: UUID().uuidString, state: .anonymous, isUserUsingGPS: false)
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
    
    func updateGPSSetting(to setting: Bool) -> Single<Result<Bool, Error>> {
//        let requestDTO = GPSSettingRequestDTO(gps: setting)
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
    
    func fetchUserLocations() -> Single<Result<[Location], Error>> {
        return Single<Result<[Location], Error>>.create { single in
            let locations = [
                Location(
                    name: "Centum Station",
                    address: "210 Haeun-daero, Haeundae-gu, Busan, South Korea",
                    latitude: 35.179495,
                    longitude: 129.124544,
                    isSelected: false
                ),
                Location(
                    name: "Pusan National University",
                    address: "2 Busandaehak-ro 63beon-gil, Geumjeong-gu, Busan, South Korea",
                    latitude: 35.2339681,
                    longitude: 129.0806855,
                    isSelected: true
                ),
                Location(
                    name: "Dongseong-ro",
                    address: "Dongseong-ro, Jung-gu, Daegu, South Korea",
                    latitude: 35.8715163,
                    longitude: 128.5959431,
                    isSelected: false
                ),
                Location(
                    name: "Pangyo-dong",
                    address: "Pangyo-dong, Bundang-gu, Seongnam-si, Gyeonggi-do, South Korea",
                    latitude: 37.3908894,
                    longitude: 127.0967915,
                    isSelected: false
                ),
            ]
                
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
                single(.success(.success(locations)))
            }
            
            return Disposables.create()
        }
    }
}