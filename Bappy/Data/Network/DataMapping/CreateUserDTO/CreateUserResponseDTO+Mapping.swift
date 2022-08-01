//
//  CreateUserResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import Foundation

struct CreateUserResponseDTO: Decodable {
    
    let user: UserDTO
    
    private enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}

extension CreateUserResponseDTO {
    struct UserDTO: Decodable {
        let id: String?
        let name: String?
        let nationality: String?
        let gender: String?
        let birth: String?
        let state: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "userId"
            case name = "userName"
            case nationality = "userNationality"
            case gender = "userGender"
            case birth = "userBirth"
            case state = "userState"
        }
    }
}

extension CreateUserResponseDTO {
    func toDomain() -> BappyUser {
        print("DEBUG: user create response \(user)")
        var state: UserState {
            switch user.state {
            case "normal": return .normal
            case "notRegistered": return .notRegistered
            default: return .notRegistered }
        }
        
        var gender: Gender? {
            guard let gender = user.gender else { return nil }
            switch gender {
            case "0": return .Male
            case "1": return .Female
            case "2": return .Other
            default: return nil }
        }
        
        return BappyUser(
            id: user.id ?? UUID().uuidString,
            state: state,
            name: user.name,
            gender: gender,
            birth: user.birth?.toDate(format: "yyyy.MM.dd"),
            nationality: user.nationality.flatMap { Country(code: $0) }
        )
    }
}
