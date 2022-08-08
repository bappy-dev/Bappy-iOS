//
//  CreateLocationRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct CreateLocationRequestDTO: Encodable {
    let locationID: String
    let locationName: String
    let locationAddress: String
    let latitude: Double
    let longitude: Double
    let isSelected: Bool
}
