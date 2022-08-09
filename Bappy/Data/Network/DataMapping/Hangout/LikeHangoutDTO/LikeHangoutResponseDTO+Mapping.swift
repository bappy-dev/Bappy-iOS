//
//  LikeHangoutResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct LikeHangoutResponseDTO: Decodable {
    
    let hasLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasLiked = "data"
    }
}

extension LikeHangoutResponseDTO {
    func toDomain() -> Bool {
        return hasLiked
    }
}
