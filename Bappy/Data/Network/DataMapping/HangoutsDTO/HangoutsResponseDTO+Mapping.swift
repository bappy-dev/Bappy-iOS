//
//  HangoutsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit

struct HangoutsResponseDTO: Decodable {}

extension HangoutsResponseDTO {
    func toDomain() -> [Hangout] {
        return []
    }
}
