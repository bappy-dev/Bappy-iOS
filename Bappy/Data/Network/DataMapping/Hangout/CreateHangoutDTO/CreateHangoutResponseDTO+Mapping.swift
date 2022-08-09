//
//  CreateHangoutResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/03.
//

import Foundation

struct CreateHangoutResponseDTO: Decodable {
    
    let hasCreated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasCreated = "data"
    }
}

extension CreateHangoutResponseDTO {
    func toDomain() -> Bool {
        return hasCreated
    }
}
