//
//  UpdateProfileResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/01.
//

import Foundation

struct UpdateProfileResponseDTO: Decodable {
    
    let hasUpdated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasUpdated = "data"
    }
}

extension UpdateProfileResponseDTO {
    func toDomain() -> Bool {
        return hasUpdated
    }
}
