//
//  SelectLocationResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct SelectLocationResponseDTO: Decodable {
    
    let hasSelected: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasSelected = "data"
    }
}

extension SelectLocationResponseDTO {
    func toDomain() -> Bool {
        return hasSelected
    }
}
