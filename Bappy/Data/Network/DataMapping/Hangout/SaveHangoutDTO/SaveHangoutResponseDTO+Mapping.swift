//
//  SaveHangoutResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 이현욱 on 2022/12/15.
//

import Foundation

struct SaveHangoutResponseDTO: Decodable {
    let status: String
    let message: String
    let data: String?
    let token: Int
}
