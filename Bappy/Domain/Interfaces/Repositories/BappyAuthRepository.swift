//
//  BappyAuthRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import RxSwift

protocol BappyAuthRepository {
    static var shared: Self { get }
    var currentUser: BehaviorSubject<BappyUser?> { get }
    func fetchCurrentUser() -> Single<Result<BappyUser, Error>>
    func fetchAnonymousUser() -> Single<BappyUser>
    func createUser(name: String, gender: Gender, birth: Date, countryCode: String) -> Single<Result<BappyUser, Error>>
    func deleteUser() -> Single<Result<Bool, Error>>
    func updateProfile(affiliation: String?, introduce: String?, languages: [Language]?, personalities: [Persnoality]?, interests: [Hangout.Category]?, data: Data?) -> Single<Result<Bool, Error>>
    func updateGPSSetting(to setting: Bool) -> Single<Result<Bool, Error>>
    func registerFCMToken(_ fcmToken: String)
    
    func fetchLocations() -> Single<Result<[Location], Error>>
    func createLocation(location: Location) -> Single<Result<Bool, Error>>
    func deleteLocation(id: String) -> Single<Result<Bool, Error>>
    func selectLocation(id: String, isSelected: Bool) -> Single<Result<Bool, Error>>
    
    func fetchNotificationSetting() -> Single<Result<NotificationSetting, Error>>
    func updateNotificationSetting(myHangout: Bool?, newHangout: Bool?) -> Single<Result<Bool, Error>>
}
