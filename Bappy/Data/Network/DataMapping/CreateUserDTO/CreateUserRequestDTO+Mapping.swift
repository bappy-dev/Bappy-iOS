//
//  CreateUserRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import Foundation

struct CreateUserRequestDTO: Encodable {
    let userName: String
    let userGender: String
    let userBirth: String
    let userNationality: String
}
