//
//  Location.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import Foundation
import Differentiator

struct Location: Equatable, IdentifiableType {
    typealias Identifier = String
    
    let identity: Identifier
    let name: String
    let address: String
    
    let coordinates: Coordinates
    
    var isSelected: Bool
    
    init(name: String, address: String, coordinates: Coordinates, isSelected: Bool) {
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.isSelected = isSelected
        self.identity = UUID().uuidString
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.identity == rhs.identity
    }
}
