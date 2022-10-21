//
//  FetchHangoutResponseDTO+Mapping.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import Foundation

struct FetchHangoutResponseDTO: Decodable {
    let hangoutDTO: HangoutDTO
    let message: String
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case hangoutDTO = "data"
    }
}

extension FetchHangoutResponseDTO {
    func toDomain() -> Hangout {
        return hangoutDTO.toDomain()
    }
}
