//
//  FetchLikedPeopleResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/04.
//

import Foundation

struct FetchLikedPeopleResponseDTO: Decodable {
    let status: String
    let token: Int
    let data: NickNameDTO
    let message: String
}

struct NickNameDTO: Decodable {
    let nicknames: [String]
    
    enum CodingKeys: String, CodingKey {
        case nicknames = "likeNicknames"
    }
}
