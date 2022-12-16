//
//  SaveHangoutRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 이현욱 on 2022/12/15.
//

import Foundation

struct SaveHangoutRequestDTO: Encodable {
    let hangoutTitle: String
    let hangoutPlan: String
    let hangoutLanguage: String
    let hangoutTotalNum: Int
    let hangoutCategory: [String]
    let hangoutMeetTime: String
    let placeName: String
    let placeLatitude: String
    let placeLongitude: String
    let hangoutOpenChat: String
}
