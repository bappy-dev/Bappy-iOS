//
//  MakeReviewRequestDTO+Mapping.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/24.
//

import Foundation

struct MakeReviewsRequestDTO: Encodable {
    let reviews: [MakeReviewRequestDTO]
    
    struct MakeReviewRequestDTO: Encodable {
        let tags: [String]
        let message: String
        let receiveId: String
        let hangoutInfoId: String
    }
}
