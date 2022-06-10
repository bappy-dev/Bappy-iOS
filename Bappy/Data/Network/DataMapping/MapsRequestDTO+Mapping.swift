//
//  MapsRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

struct MapsRequestDTO: Encodable {
    let key: String
    let query: String
    let language: String
}

struct MapsNextRequestDTO: Encodable {
    let key: String
    let pagetoken: String
    let language: String
}
