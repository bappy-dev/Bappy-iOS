//
//  GoogleMapsRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/26.
//

import Foundation
import RxSwift

protocol GoogleMapsRepository {
    func fetchMapPage(param: (key: String, query: String, language: String)) -> Single<Result<MapPage, Error>>
    func fetchNextMapPage(param: (key: String, pageToken: String, language: String)) -> Single<Result<MapPage, Error>>
}
