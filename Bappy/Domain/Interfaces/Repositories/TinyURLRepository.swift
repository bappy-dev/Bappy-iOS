//
//  TinyURLRepository.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/18.
//

import Foundation
import RxSwift

protocol TinyURLRepository {
    func getTinyURL(with URL: URL) -> Single<Result<String, Error>>
}
