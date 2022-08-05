//
//  UpdateHangoutParticipationResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct UpdateHangoutParticipationResponseDTO: Decodable {
    
    let hasUpdated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasUpdated = "data"
    }
}

extension UpdateHangoutParticipationResponseDTO {
    func toDomain() -> Bool {
        return hasUpdated
    }
}
