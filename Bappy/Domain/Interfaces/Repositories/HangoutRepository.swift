//
//  HangoutRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation
import RxSwift

protocol HangoutRepository {
    func fetchHangouts(param: (sorting: String?, category: String?, coordinates: String?, token: String)) -> Single<Result<[Hangout], Error>>
}
