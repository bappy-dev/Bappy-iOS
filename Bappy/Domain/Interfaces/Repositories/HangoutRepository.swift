//
//  HangoutRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation
import RxSwift

protocol HangoutRepository {
    func fetchHangouts(sorting: Hangout.Sorting?, category: Hangout.Category?, coordinates: String?) -> Single<Result<[Hangout], Error>>
    func createHangout(hangout: Hangout, imageData: Data) -> Single<Result<Bool, Error>>
    func deleteHangout(id hangoutID: String) -> Single<Result<Bool, Error>>
    func likeHangout(id hangoutID: String, hasUserLiked: Bool) -> Single<Result<Bool, Error>>
    func joinHangout(id hangoutID: String) -> Single<Result<Bool, Error>>
    func cancelHangout(id hangoutID: String) -> Single<Result<Bool, Error>>
    func reportHangout(hangoutID: String, reportType: String, detail: String, imageDatas: [Data]?) -> Single<Result<Bool, Error>>
}
