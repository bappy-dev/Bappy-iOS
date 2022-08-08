//
//  SelectLocationRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct SelectLocationRequestDTO: Encodable {
    let locationID: String
    let isSelected: Bool
}
