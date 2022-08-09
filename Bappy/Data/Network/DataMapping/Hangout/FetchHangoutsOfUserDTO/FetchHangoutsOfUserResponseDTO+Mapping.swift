//
//  FetchHangoutsOfUserResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct FetchHangoutsOfUserResponseDTO: Decodable {}

extension FetchHangoutsOfUserResponseDTO {
    func toDomain() -> [Hangout] {
        return []
    }
}
