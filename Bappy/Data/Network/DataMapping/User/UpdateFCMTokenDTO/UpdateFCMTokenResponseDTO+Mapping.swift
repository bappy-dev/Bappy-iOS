//
//  UpdateFCMTokenResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/04.
//

import Foundation

struct UpdateFCMTokenResponseDTO: Decodable {
    
    let hasUpdated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasUpdated = "data"
    }
}

extension UpdateFCMTokenResponseDTO {
    func toDomain() -> Bool {
        return hasUpdated
    }
}
