//
//  ReportHangoutRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/04.
//

import Foundation

struct ReportHangoutRequestDTO: Encodable {
    let hangoutID: String
    let reportTitle: String
    let reportDetail: String
}
