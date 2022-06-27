//
//  Map.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import UIKit

struct Map: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    
    let name: String
    let address: String
    
    let coordinates: Coordinates
    
    let iconURL: URL?
    
    static func == (lhs: Map, rhs: Map) -> Bool {
        lhs.id == rhs.id
    }
}

struct MapPage: Equatable {
    let nextPageToken: String?
    let maps: [Map]
}
