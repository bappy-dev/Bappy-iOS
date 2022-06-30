//
//  BappyUser.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import UIKit

enum Gender: String { case male, female, other }
enum UserState { case normal, anonymous, notRegistered, abuser }
enum Persnoality: String { case spontaneous, planning, talkative, shy, empathatic, calm, polite }
typealias Language = String

struct BappyUser: Equatable, Identifiable {
    typealias Identifier = String
    
    // Required
    let id: Identifier // UUID
    var state: UserState
    
    // Optional
    var isUserUsingGPS: Bool?
    var coordinates: Coordinates?
    
    var name: String?
    var gender: Gender?
    var birth: String?
    var nationality: Country?
    
    var profileImageURL: URL?
    var introduce: String?
    var affiliation: String?
    var languages: [Language]?
    var personalities: [Persnoality]?
    var interests: [HangoutCategory]?
    
    var numOfJoinedHangouts: Int?
    var madeHangouts: Int?
    var likedHangouts: Int?
    
    static func == (lhs: BappyUser, rhs: BappyUser) -> Bool {
        lhs.id == rhs.id
    }
}
