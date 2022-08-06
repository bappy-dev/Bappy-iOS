//
//  FetchHangoutsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation

struct FetchHangoutsResponseDTO: Decodable {}

extension FetchHangoutsResponseDTO {
    func toDomain() -> [Hangout] {
        return []
    }
}
