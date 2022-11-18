//
//  CreateTinyURLResponse.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/18.
//

import Foundation

struct CreateTinyURLResponseDTO: Decodable {
    let data: TinyData
    let code: Int
    let errors: [String]
}

struct TinyData: Decodable {
    let domain: String
    let alias: String
    let deleted: Bool
    let archived: Bool
    let tiny_url: String
    let url: String
}

//{
//  "data": {
//    "domain": "tinyurl.com",
//    "alias": "example-alias",
//    "deleted": false,
//    "archived": false,
//    "tags": [
//      "tag1",
//      "tag2"
//    ],
//    "analytics": [
//      {
//        "enabled": true,
//        "public": false
//      }
//    ],
//    "tiny_url": "https://tinyurl.com/example-alias",
//    "url": "http://google.com"
//  },
//  "code": 0,
//  "errors": []
//}
