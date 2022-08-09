//
//  DefaultGoogleMapImageRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/27.
//

import Foundation
import RxSwift

final class DefaultGoogleMapImageRepository {
    
    private let provider: Provider
    
    init(provider: Provider = PublicProvider()) {
        self.provider = provider
    }
}

extension DefaultGoogleMapImageRepository: GoogleMapImageRepository {
    func fetchMapImageData(key: String, coordinates: Coordinates) -> Single<Result<Data, Error>> {
        let requestDTO = FetchMapImageRequestDTO(
            key: key, size: "400x170", zoom: "15", scale: "2",
            center: "\(coordinates.latitude),\(coordinates.longitude)",
            markers: "color:red|\(coordinates.latitude - 0.0012),\(coordinates.longitude)")
        let endpoint = APIEndpoints.fetchGoogleMapImage(with: requestDTO)
        return  provider.request(endpoint)
            .map { result -> Result<Data, Error> in
                switch result {
                case .success(let data):
                    return .success(data)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
