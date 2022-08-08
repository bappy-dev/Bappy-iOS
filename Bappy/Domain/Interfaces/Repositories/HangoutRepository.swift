//
//  HangoutRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation
import RxSwift

protocol HangoutRepository {
    func fetchHangouts(page: Int, sorting: Hangout.SortingOrder, category: Hangout.Category, coordinates: Coordinates?) -> Single<Result<HangoutPage, Error>>
    func fetchHangouts(userID: String, profileType: Hangout.UserProfileType) -> Single<Result<[Hangout], Error>> 
    func createHangout(hangout: Hangout, imageData: Data) -> Single<Result<Bool, Error>>
    func deleteHangout(hangoutID: String) -> Single<Result<Bool, Error>>
    func likeHangout(hangoutID: String, hasUserLiked: Bool) -> Single<Result<Bool, Error>>
    func joinHangout(hangoutID: String) -> Single<Result<Bool, Error>>
    func cancelHangout(hangoutID: String) -> Single<Result<Bool, Error>>
    func reportHangout(hangoutID: String, reportType: String, detail: String, imageDatas: [Data]?) -> Single<Result<Bool, Error>>
}
