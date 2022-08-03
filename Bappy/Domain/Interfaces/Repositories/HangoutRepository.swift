//
//  HangoutRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation
import UIKit.UIImage
import RxSwift

protocol HangoutRepository {
    func fetchHangouts(sorting: Hangout.Sorting?, category: Hangout.Category?, coordinates: String?) -> Single<Result<[Hangout], Error>>
    func createHangout(hangout: Hangout) -> Single<Result<Bool, Error>>
}
