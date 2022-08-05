//
//  DeleteHangoutResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct DeleteHangoutResponseDTO: Decodable {
    
    let hasDeleted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasDeleted = "data"
    }
}

extension DeleteHangoutResponseDTO {
    func toDomain() -> Bool {
        return hasDeleted
    }
}
