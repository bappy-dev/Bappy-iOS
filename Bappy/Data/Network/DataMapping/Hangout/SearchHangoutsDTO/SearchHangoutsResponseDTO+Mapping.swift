//
//  SearchHangoutsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/09.
//

import Foundation

import Foundation

struct SearchHangoutsResponseDTO: Decodable {
    
    let totalPage: Int
    let hangoutDTOs: [HangoutDTO]
    
    private enum CodingKeys: String, CodingKey {
        case totalPage
        case hangoutDTOs = "data"
    }
}

extension SearchHangoutsResponseDTO {
    func toDomain() -> HangoutPage {
        let hangouts = hangoutDTOs
            .map { $0.toDomain() }
        return HangoutPage(totalPage: 0, hangouts: hangouts)
    }
}

