//
//  GetGPSResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/22.
//

import Foundation

struct GetGPSResponseDTO: Decodable {
    let status: String
    let message: String
    let data: Bool
    let token: Int
}
