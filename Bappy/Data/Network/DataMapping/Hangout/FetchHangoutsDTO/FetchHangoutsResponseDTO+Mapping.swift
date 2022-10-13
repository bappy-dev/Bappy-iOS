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
            .map { element -> Hangout in
                var state: Hangout.State {
                    switch element.status {
                    case "available": return .available
                    case "closed": return .closed
                        default: return .expired }
                }
                
                let date = element.meetTime.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? Date()
                let coordinates = Coordinates(latitude: 0.0, longitude: 0.0)
                let postImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/\(element.postImageFilename)")
                let mapImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/")
                
                return Hangout(
                    id: element.id,
                    state: state,
                    title: element.title,
                    meetTime: date,
                    language: element.language,
                    placeID: "",
                    placeName: element.placeName,
                    plan: element.plan,
                    limitNumber: element.limitNumber, placeAddress: "",
                    categories: [],
                    coordinates: coordinates,
                    postImageURL: postImageURL,
                    openchatURL: URL(string: element.openchatURL),
                    mapImageURL: mapImageURL,
                    participantIDs: [],
                    userHasLiked: false
                )
            }
        
        return HangoutPage(totalPage: hangoutDTOs.pageInfo.totalCount, hangouts: hangouts)
    }
}

extension FetchHangoutsResponseDTO {
    struct FetchHangoutListDTO: Decodable {
        var HangoutList: [HangoutDTO]
        var pageInfo: PageInfoDTO
    }
    
    struct PageInfoDTO:Decodable {
        var totalCount: Int
        var currentCount: Int
    }
    
    struct HangoutDTO: Decodable {
        let id: String
        let meetTime: String
        let title: String
        let plan: String
        let postImageFilename: String
        let language: String
        let openchatURL: String
        let limitNumber: Int
        let currentNum: Int
        let likeCount: Int
        let placeImageURL: String
        let placeName: String
        let joinedUserIDs: [String]
        let joinedUserImageURL: [String]
        let likedUserIDs: [String]
        let likedUserImageURL: [String]
        let status: String
        let likeStatus: Bool
        let joinedStatus: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id = "hangoutInfoId"
            case meetTime = "hangoutMeetTime"
            case title = "hangoutTitle"
            case plan = "hangoutPlan"
            case postImageFilename = "hangoutImageUrl"
            case language = "hangoutLanguage"
            case openchatURL = "hangoutOpenChat"
            case limitNumber = "hangoutTotalNum"
            case currentNum = "hangoutCurrentNum"
            case likeCount = "hangoutLikeCount"
            case placeImageURL = "hangoutPlaceImageUrl"
            case placeName = "hangoutPlaceName"
            case joinedUserIDs = "hangoutJoinUserId"
            case joinedUserImageURL = "hangoutJoinUserImageUrl"
            case likedUserIDs = "hangoutLikeUserId"
            case likedUserImageURL = "hangoutLikeUserImageUrl"
            case status = "hangoutStatus"
            case likeStatus = "hangoutLikeStatus"
            case joinedStatus = "hangoutJoinStatus"
        }
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
