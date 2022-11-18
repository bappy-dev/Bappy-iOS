//
//  DefaultTinyURLRepository.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/18.
//

import UIKit
import RxSwift

final class DefaultTinyURLRepository {
    
    private let provider: Provider
    
    init(provider: Provider = PublicProvider()) {
        self.provider = provider
    }
}

extension DefaultTinyURLRepository: TinyURLRepository {
    func getTinyURL(with URL: URL) -> Single<Result<String, Error>> {
        
        let request = CreateTinyURLRequestDTO(url: URL.absoluteString,
                                              domain: "",
                                              alias: "",
                                              tags: "",
                                              expires_at: "")
        let endpoint = APIEndpoints.createTinyURL(with: request)
        endpoint.headers?["Authorization"] = "Bearer CTG0NgHs0ir8bourBB1vAByxDlrgqqM1tXofCDuDhTptS2u82RlShybmETx8"
        return  provider.request(with: endpoint)
            .map { result -> Result<String, Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.data.tiny_url)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
