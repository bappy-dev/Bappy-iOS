//
//  DeleteUserResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct DeleteUserResponseDTO: Decodable {
    
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}

extension DeleteUserResponseDTO {
    func toDomain() -> Bool {
        return status == "OK"
    }
}
