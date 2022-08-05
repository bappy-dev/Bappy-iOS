//
//  FetchProfileResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation

struct FetchProfileResponseDTO: Decodable {
    
    let user: UserDTO
    
    private enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}

extension FetchProfileResponseDTO {
    struct UserDTO: Decodable {
        let id: String?
        let name: String?
        let nationality: String?
        let gender: String?
        let birth: String?
        let affiliation: String?
        let introduce: String?
        let profileImageFilename: String?
        let state: String
        let languages: [String]?
        let personalities: [String]?
        let interests: [String]?
        
        private enum CodingKeys: String, CodingKey {
            case id = "userInfoID"
            case name = "userName"
            case nationality = "userNationality"
            case gender = "userGender"
            case birth = "userBirth"
            case affiliation = "userAffiliation"
            case introduce = "userIntroduce"
            case profileImageFilename = "userProfileImageURL"
            case state = "userState"
            case languages = "userLanguages"
            case personalities = "userPersonalities"
            case interests = "userInterests"
        }
    }
}

extension FetchProfileResponseDTO {
    func toDomain() -> BappyUser {
        let profileImageURL = user.profileImageFilename
            .flatMap { URL(string: "\(BAPPY_API_BASEURL)static-file/\($0)") }
        return BappyUser(
            id: user.id ?? UUID().uuidString,
            state: .normal, // 임시
            coordinates: nil, // 임시
            name: user.name,
            gender: nil, // 임시
            birth: nil, // 임시
            nationality: nil, // 임시
            profileImageURL: profileImageURL,
            introduce: user.introduce,
            affiliation: user.affiliation,
            languages: user.languages,
            personalities: nil, // 임시
            interests: nil // 임시
        )
    }
}
