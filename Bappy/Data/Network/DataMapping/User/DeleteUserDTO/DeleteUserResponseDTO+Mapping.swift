//
//  DeleteUserResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct DeleteUserResponseDTO: Decodable {
    
    let hasDeleted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasDeleted = "data"
    }
}

extension DeleteUserResponseDTO {
    func toDomain() -> Bool {
        return hasDeleted
    }
}
