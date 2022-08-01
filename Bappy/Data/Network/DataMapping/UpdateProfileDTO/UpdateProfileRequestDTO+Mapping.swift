//
//  UpdateProfileRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/01.
//

import Foundation

struct UpdateProfileRequestDTO: Encodable {
    let userAffiliation: String?
    let userIntroduce: String?
    let userLanguages: String?
    let userInterests: String?
    let userPersonalities: String?
}
