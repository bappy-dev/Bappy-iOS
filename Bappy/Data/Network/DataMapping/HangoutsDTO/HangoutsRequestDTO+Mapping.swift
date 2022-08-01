//
//  HangoutsRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation

struct HangoutsRequestDTO: Encodable {
    let sorting: String?
    let category: String?
    let coordinates: String?
}
