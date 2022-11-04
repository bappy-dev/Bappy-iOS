//
//  FetchNotificationSettingResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct FetchNotificationSettingResponseDTO: Decodable {
    
    let notificationSettingDTO: NotificationsDTO
    
    private enum CodingKeys: String, CodingKey {
        case notificationSettingDTO = "data"
    }
}

extension FetchNotificationSettingResponseDTO {
    struct NotificationsDTO: Decodable {
        let myHangout: Bool
        let newHangout: Bool
        
        private enum CodingKeys: String, CodingKey {
            case myHangout = "hangoutNoti"
            case newHangout = "newHangoutNoti"
        }
    }
    
    func toDomain() -> NotificationSetting {
        return .init(
            myHangout: notificationSettingDTO.myHangout,
            newHangout: notificationSettingDTO.newHangout
        )
    }
}
