//
//  HangoutDTO.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import Foundation

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
    
    func toDomain() -> Hangout {
        var state: Hangout.State {
            switch status {
            case "open": return .available
            case "closed": return .closed
                default: return .expired }
        }
        
        let date = meetTime.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? Date()
        let coordinates = Coordinates(latitude: 0.0, longitude: 0.0)
        let postImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/\(postImageFilename)")
        let mapImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/")
        
        return Hangout(
            id: id,
            state: state,
            title: title,
            meetTime: date,
            language: language,
            placeID: "",
            placeName: placeName,
            plan: plan,
            limitNumber: limitNumber, placeAddress: "",
            categories: [],
            coordinates: coordinates,
            postImageURL: postImageURL,
            openchatURL: URL(string: openchatURL),
            mapImageURL: mapImageURL,
            participantIDs: [],
            userHasLiked: likeStatus
        )
    }
}
