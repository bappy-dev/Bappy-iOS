//
//  FetchHangoutsOfUserResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct FetchHangoutsOfUserResponseDTO: Decodable {
    let hangoutDTOs: FetchHangoutListDTO
    let message: String
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case hangoutDTOs = "data"
    }
}

extension FetchHangoutsOfUserResponseDTO {
    func toDomain() -> [Hangout] {
        return hangoutDTOs.HangoutList
            .map { $0.toDomain() }
    }
}

extension FetchHangoutsOfUserResponseDTO {
    struct FetchHangoutListDTO: Decodable {
        var HangoutList: [HangoutDTO]
        var pageInfo: PageInfoDTO?
    }
    
    struct PageInfoDTO:Decodable {
        var totalCount: Int
        var currentCount: Int
    }
}
