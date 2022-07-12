//
//  Location.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import UIKit
import Differentiator

struct Location: Equatable, IdentifiableType {
    
    let identity: String
    let name: String
    let address: String
    
    let latitude: CGFloat
    let longitude: CGFloat
    
    let isSelected: Bool
    
    init(name: String, address: String, latitude: CGFloat, longitude: CGFloat, isSelected: Bool) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isSelected = isSelected
        self.identity = UUID().uuidString
    }
}
