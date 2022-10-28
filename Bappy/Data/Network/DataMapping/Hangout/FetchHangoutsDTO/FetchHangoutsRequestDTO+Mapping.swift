//
//  FetchHangoutsRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation

struct FetchHangoutsRequestDTO: Encodable {
    var hangoutSort: String
    var hangoutCategory: String
//    let page: Int
//    let sorting: String
//    let category: String
//    let coordinates: String?
}
