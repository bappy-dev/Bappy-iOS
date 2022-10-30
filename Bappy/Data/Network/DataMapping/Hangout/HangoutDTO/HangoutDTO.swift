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
    let place: PlaceDTO
    let joinedUserIDs: [String]
    let joinedUserImageName: [String]
    let likedUserIDs: [String]
    let likedUserImageName: [String]
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
        case place = "place"
        case joinedUserIDs = "hangoutJoinUserId"
        case joinedUserImageName = "hangoutJoinUserImageUrl"
        case likedUserIDs = "hangoutLikeUserId"
        case likedUserImageName = "hangoutLikeUserImageUrl"
        case status = "hangoutStatus"
        case likeStatus = "hangoutLikeStatus"
        case joinedStatus = "hangoutJoinStatus"
    }
}

extension HangoutDTO {
    struct PlaceDTO: Decodable {
        let name: String
        let latitude: Double
        let longitude: Double
        let address: String
        
        private enum CodingKeys: String, CodingKey {
            case name = "placeName"
            case latitude = "placeLatitude"
            case longitude = "placeLongitude"
            case address = "placeAddress"
        }
    }
    
    func toDomain() -> Hangout {
        var state: Hangout.State {
            switch status {
            case "open": return .available
            case "closed": return .closed
                default: return .expired }
        }
        let date = meetTime.toDate(format: "yyyy-MM-dd HH:mm") ?? Date()
        let postImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/\(postImageFilename)")
        let place = Hangout.Place(name: place.name, address: place.address, latitude: place.latitude, longitude: place.longitude)
        
        return Hangout(id: id,
                       state: state,
                       title: title,
                       meetTime: date,
                       language: language,
                       plan: plan,
                       limitNumber: limitNumber,
                       categories: [],
                       place: place,
                       postImageURL: postImageURL,
                       openchatURL: URL(string: openchatURL)!,
                       joinedIDs: zip(joinedUserIDs, joinedUserImageName).map({ Hangout.Info(id: $0,imageURL: URL(string: "\(BAPPY_API_BASEURL)static-file/\($1)")!) }),
                       likedIDs: zip(likedUserIDs, likedUserImageName).map({ Hangout.Info(id: $0, imageURL: URL(string: "\(BAPPY_API_BASEURL)static-file/\($1)")!) }),
                       userHasLiked: likeStatus)
    }
}
