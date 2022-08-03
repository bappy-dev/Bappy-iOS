//
//  MapImageRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/27.
//

import Foundation

struct MapImageRequestDTO: Encodable {
    let key: String
    let size: String
    let zoom: String
    let scale: String
    let center: String
    let markers: String
}
