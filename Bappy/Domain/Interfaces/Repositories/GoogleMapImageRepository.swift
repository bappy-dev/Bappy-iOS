//
//  GoogleMapImageRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/27.
//

import Foundation
import RxSwift

protocol GoogleMapImageRepository {
    func fetchMapImageData(key: String, coordinates: Coordinates) -> Single<Result<Data, Error>>
}
