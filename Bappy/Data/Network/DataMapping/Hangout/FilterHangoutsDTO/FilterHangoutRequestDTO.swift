//
//  FilterHangoutRequestDTO.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/16.
//

import Foundation

struct FilterHangoutRequestDTO: Encodable {
    var week: [String]
    var language: [String]
    var hangoutCategory: [String]
    var startDate: String
    var endDate: String
}
