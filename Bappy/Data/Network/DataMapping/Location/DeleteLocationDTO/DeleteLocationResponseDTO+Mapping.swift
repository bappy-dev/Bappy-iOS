//
//  DeleteLocationResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct DeleteLocationResponseDTO: Decodable {
    
    let hasDeleted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasDeleted = "data"
    }
}

extension DeleteLocationResponseDTO {
    func toDomain() -> Bool {
        return hasDeleted
    }
}
