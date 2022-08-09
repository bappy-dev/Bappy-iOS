//
//  ReportHangoutResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/04.
//

import Foundation

struct ReportHangoutResponseDTO: Decodable {
    
    let hasReported: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hasReported = "data"
    }
}

extension ReportHangoutResponseDTO {
    func toDomain() -> Bool {
        return hasReported
    }
}
