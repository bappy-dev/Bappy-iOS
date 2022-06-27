//
//  GoogleMapImageRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/27.
//

import UIKit
import RxSwift

protocol GoogleMapImageRepository {
    func fetchMapImage(param: (key: String, latitude: CGFloat, longitude: CGFloat)) -> Single<Result<UIImage?, Error>>
}
