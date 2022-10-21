//
//  FetchHangoutsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import Foundation

struct FetchHangoutsResponseDTO: Decodable {
    let hangoutDTOs: FetchHangoutListDTO
    let message: String
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case hangoutDTOs = "data"
    }
}

extension FetchHangoutsResponseDTO {
    func toDomain() -> HangoutPage {
        let hangouts = hangoutDTOs.HangoutList
            .map { $0.toDomain() }
        
        return HangoutPage(totalPage: hangoutDTOs.pageInfo?.totalCount ?? 0, hangouts: hangouts)
    }
}

extension FetchHangoutsResponseDTO {
    struct FetchHangoutListDTO: Decodable {
        var HangoutList: [HangoutDTO]
        var pageInfo: PageInfoDTO?
    }
    
    struct PageInfoDTO:Decodable {
        var totalCount: Int
        var currentCount: Int
    }
    
    //    struct InfoDTO: Decodable {
    //        let id: String
    //        let profileImageFilename: String
    //
    //        private enum CodingKeys: String, CodingKey {
    //            case id = "userId"
    //            case profileImageFilename = "userProfileImageUrl"
    //        }
    //    }
    
}
