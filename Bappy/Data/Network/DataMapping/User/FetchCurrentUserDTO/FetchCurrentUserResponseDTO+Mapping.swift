//
//  FetchCurrentUserResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import SwiftUI

struct FetchCurrentUserResponseDTO: Decodable {
    
    let user: UserDTO
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case user = "data"
        case message
    }
}

extension FetchCurrentUserResponseDTO {
    struct UserDTO: Decodable {
        let id: String?
        let name: String?
        let nationalityCode: String?
        let gender: String?
        let birth: String?
        let affiliation: String?
        let introduce: String?
        let profileImageFilename: String?
        let isUserUsingGPS: Bool?
        let state: String?
        let languages: [String]?
        let personalities: [String]?
        let interests: [String]?
        
        private enum CodingKeys: String, CodingKey {
            case id = "userId"
            case name = "userName"
            case nationalityCode = "userNationalityCode"
            case gender = "userGender"
            case birth = "userBirth"
            case affiliation = "userAffiliation"
            case introduce = "userIntroduce"
            case profileImageFilename = "userProfileImageUrl"
            case isUserUsingGPS = "userGPS"
            case state = "userState"
            case languages = "userLanguages"
            case personalities = "userPersonalities"
            case interests = "userInterests"
        }
    }
}

extension FetchCurrentUserResponseDTO {
    func toDomain() -> BappyUser {
        print("DEBUG: user response \(user)")
        var state: UserState {
            switch user.state {
            case "normal": return .normal
            case "notRegistered": return .notRegistered
            default: return message == "normal user" ? .normal : .notRegistered }
        }
        
        var gender: Gender? {
            guard let gender = user.gender else { return nil }
            switch gender {
            case "0": return .Male
            case "1": return .Female
            case "2": return .Other
            default: return nil }
        }
        
        let profileImageURL = user.profileImageFilename
            .flatMap { URL(string: "\(BAPPY_API_BASEURL)static-file/\($0)") }
        
        let personalities = user.personalities
            .map { $0.compactMap { Persnoality(rawValue: $0) } }
        
        let interests = user.interests
            .map { $0.compactMap { interest -> Hangout.Category? in
                switch interest {
                case "Travel": return .Travel
                case "Cafe": return .Cafe
                case "Hiking": return .Hiking
                case "Food": return .Food
                case "Bar": return .Bar
                case "Cook": return .Cook
                case "Shopping": return .Shopping
                case "Volunteer": return .Volunteer
                case "Language": return .Language
                case "Crafting": return .Crafting
                case "BallGame": return .BallGame
                case "Running": return .Running
                case "Concerts": return .Concerts
                case "Museum": return .Museum
                case "Music": return .Music
                case "Vegan": return .Vegan
                case "Boardgame": return .Boardgame
                default: return nil }
            }}
        
        return BappyUser(
            id: user.id ?? UUID().uuidString,
            state: state,
            isUserUsingGPS: user.isUserUsingGPS,
            coordinates: nil, // 임시
            name: user.name,
            gender: gender,
            birth: user.birth?.toDate(format: "yyyy.MM.dd"),
            nationality: user.nationalityCode.flatMap { Country(code: $0) },
            profileImageURL: profileImageURL,
            introduce: user.introduce,
            affiliation: user.affiliation,
            languages: user.languages,
            personalities: personalities,
            interests: interests
        )
    }
}
