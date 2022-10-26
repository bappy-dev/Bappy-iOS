//
//  Map.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

struct Map {
    let name: String
    let address: String
    
    let coordinates: Coordinates
    
    let iconURL: URL?
}

struct MapPage {
    let nextPageToken: String?
    let maps: [Map]
}
