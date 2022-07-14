//
//  GPSSettingResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/13.
//

import Foundation

struct GPSSettingResponseDTO: Decodable {
    
    let isUserUsingGPS: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isUserUsingGPS = "data"
    }
}

extension GPSSettingResponseDTO {
    func toDomain() -> Bool {
        return isUserUsingGPS
    }
}
