//
//  MakeReviewRequestDTO+Mapping.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/24.
//

import Foundation

struct MakeReviewRequestDTO: Encodable {
    let tags: [String]
    let message: String
    let receiveId: String
    let hangoutInfoId: String
}
