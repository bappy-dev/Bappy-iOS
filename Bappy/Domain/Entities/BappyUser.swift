//
//  BappyUser.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import UIKit

enum Gender: String { case Male, Female, Other }
enum UserState { case normal, anonymous, notRegistered, abuser }
enum Persnoality: String { case Spontaneous, Planning, Talkative, Shy, Empathatic, Calm, Polite }
typealias Language = String

struct BappyUser: Equatable, Identifiable {
    typealias Identifier = String
    
    // Required
    let id: Identifier
    var state: UserState
    
    // Optional
    var isUserUsingGPS: Bool?
    var coordinates: Coordinates?
    
    var name: String?
    var gender: Gender?
    var birth: Date?
    var nationality: Country?
    
    var profileImageURL: URL?
    var introduce: String?
    var affiliation: String?
    var languages: [Language]?
    var personalities: [Persnoality]?
    var interests: [Hangout.Category]?
    
    var numOfJoinedHangouts: Int?
    var numOfMadeHangouts: Int?
    var numOfLikedHangouts: Int?
    
    static func == (lhs: BappyUser, rhs: BappyUser) -> Bool {
        lhs.id == rhs.id
    }
}
