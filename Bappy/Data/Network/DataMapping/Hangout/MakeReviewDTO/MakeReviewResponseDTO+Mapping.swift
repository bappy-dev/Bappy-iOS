//
//  MakeReviewResponseDTO+Mapping.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/24.
//

import Foundation

struct MakeReviewResponseDTO: Decodable {
    
    let hasCreated: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasCreated = "data"
    }
}

extension MakeReviewResponseDTO {
    func toDomain() -> Bool {
        return hasCreated
    }
}
