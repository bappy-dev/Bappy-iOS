//
//  CreateLocationResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct CreateLocationResponseDTO: Decodable {
    
    let hasCreated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasCreated = "data"
    }
}

extension CreateLocationResponseDTO {
    func toDomain() -> Bool {
        return hasCreated
    }
}
