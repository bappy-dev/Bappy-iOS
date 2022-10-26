//
//  UpdateHangoutParticipationResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct UpdateHangoutParticipationResponseDTO: Decodable {
    let status: String
    let data: Bool
    let token: String
    let message: String
}

extension UpdateHangoutParticipationResponseDTO {
//    func toDomain() -> Bool {
//        return data == "true"
//    }
}
