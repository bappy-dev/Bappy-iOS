//
//  UpdateNotificationSettingRequestDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct UpdateNotificationSettingRequestDTO: Encodable {
    let myHangout: Bool?
    let newHangout: Bool?
}
