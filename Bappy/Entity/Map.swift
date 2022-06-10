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
    
    let latitude: CGFloat
    let longitude: CGFloat
    
    let iconURL: URL?
}

struct MapPage: Equatable {
    let nextPageToken: String?
    let maps: [Map]
}
