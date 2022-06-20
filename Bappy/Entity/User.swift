//
//  User.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import Foundation

enum Gender: String { case male, female, other }
enum UserState { case normal, anonymous, notRegistered, abuser }
enum Persnoality: String { case spontaneous, planning, talkative, shy, empathatic, calm, polite }

struct User: Equatable, Identifiable {
    typealias Identifier = String
    
    // Required
    let id: Identifier // UUID
    let state: UserState
    
    // Optional
    let profileURL: URL?
    
    let name: String?
    let gender: Gender?
    let birth: String?
    let nationality: Country?
    
    let introduce: String?
    let affiliation: String?
    let languages: [String]?
    let personalities: [Persnoality]?
    let interests: [HangoutCategory]?
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
