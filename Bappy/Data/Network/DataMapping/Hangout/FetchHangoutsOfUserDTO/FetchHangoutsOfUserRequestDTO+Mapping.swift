//
//  FetchHangoutsOfUserRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/05.
//

import Foundation

struct FetchHangoutsOfUserRequestDTO: Encodable {
    let userID: String
    let userProfileType: String
}
