//
//  DefaultGoogleMapImageRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/27.
//

import UIKit
import RxSwift

final class DefaultGoogleMapImageRepository {
    
    private let provider: Provider
    
    init(provider: Provider = PublicProvider()) {
        self.provider = provider
    }
}

extension DefaultGoogleMapImageRepository: GoogleMapImageRepository {
    func fetchMapImage(param: (key: String, latitude: CGFloat, longitude: CGFloat)) -> Single<Result<UIImage?, Error>> {
        let requestDTO = MapImageRequestDTO(
            key: param.key, size: "400x170", zoom: "15", scale: "2",
            center: "\(param.latitude),\(param.longitude)",
            markers: "color:red|\(param.latitude - 0.0012),\(param.longitude)"
        )
        let endpoint = APIEndpoints.getGoogleMapImage(with: requestDTO)
        return  provider.request(endpoint)
            .map { result -> Result<UIImage?, Error> in
                switch result {
                case .success(let data):
                    return .success(UIImage(data: data))
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
