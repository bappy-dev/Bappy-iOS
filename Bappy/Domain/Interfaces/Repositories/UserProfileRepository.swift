//
//  UserProfileRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import RxSwift

protocol UserProfileRepository {
    func fetchBappyUser(id: String) -> Single<Result<BappyUser, Error>>
}
