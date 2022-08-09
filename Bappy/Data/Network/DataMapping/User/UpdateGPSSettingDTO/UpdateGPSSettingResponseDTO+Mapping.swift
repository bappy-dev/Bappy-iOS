//
//  UpdateGPSSettingResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/13.
//

import Foundation

struct UpdateGPSSettingResponseDTO: Decodable {
    
    let hasUpdated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasUpdated = "data"
    }
}

extension UpdateGPSSettingResponseDTO {
    func toDomain() -> Bool {
        return hasUpdated
    }
}
