//
//  User.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import Foundation

enum Gender: String { case male, female, other }

struct User: Equatable, Identifiable {
    typealias Identifier = String
    
    // Required
    let id: Identifier
    let name: String
    let gender: Gender
    let birth: String
    let nationality: Country
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
