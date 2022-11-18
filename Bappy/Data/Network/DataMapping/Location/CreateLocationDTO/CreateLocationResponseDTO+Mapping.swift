//
//  CreateLocationResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/18.
//

import Foundation

struct CreateLocationResponseDTO: Decodable {
    let data: [HangoutDTO]
    let message: String
    let status: String
}
