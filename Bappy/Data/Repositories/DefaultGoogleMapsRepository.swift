//
//  DefaultGoogleMapsRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/26.
//

import Foundation
import RxSwift

final class DefaultGoogleMapsRepository {
    
    private let provider: Provider
    
    init(provider: Provider = PublicProvider()) {
        self.provider = provider
    }
}

extension DefaultGoogleMapsRepository: GoogleMapsRepository {
    public func fetchMapPage(param: (key: String, query: String, language: String)) -> Single<Result<MapPage, Error>> {
        let requestDTO = FetchMapsRequestDTO(key: param.key, query: param.query, language: param.language)
        let endpoint = APIEndpoints.searchGoogleMapList(with: requestDTO)
        return  provider.request(with: endpoint)
            .map { result -> Result<MapPage, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    public func fetchNextMapPage(param: (key: String, pageToken: String, language: String)) -> Single<Result<MapPage, Error>> {
        let requestDTO = FetchMapsNextRequestDTO(key: param.key, pagetoken: param.pageToken, language: param.language)
        let endpoint = APIEndpoints.searchGoogleMapNextList(with: requestDTO)
        return  provider.request(with: endpoint)
            .map { result -> Result<MapPage, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
