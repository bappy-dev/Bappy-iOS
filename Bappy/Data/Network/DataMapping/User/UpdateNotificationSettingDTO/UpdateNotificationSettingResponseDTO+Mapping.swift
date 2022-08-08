//
//  UpdateNotificationSettingResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct UpdateNotificationSettingResponseDTO: Decodable {
    
    let hasUpdated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasUpdated = "data"
    }
}

extension UpdateNotificationSettingResponseDTO {
    func toDomain() -> Bool {
        return hasUpdated
    }
}
