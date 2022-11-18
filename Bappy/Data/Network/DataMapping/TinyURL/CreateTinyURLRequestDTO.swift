//
//  CreateTinyURLRequestDTO.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/18.
//

import Foundation

struct CreateTinyURLRequestDTO: Encodable {
    let url: String
    let domain: String
    let alias: String
    let tags: String
    let expires_at: String
}


//
//"url": "https://www.example.com/my-really-long-link-that-I-need-to-shorten/84378949",
//"domain": "tiny.one",
//"alias": "myexamplelink",
//"tags": "example,link",
//"expires_at": "2024-10-25 10:11:12"
//}
