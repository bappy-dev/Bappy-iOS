//
//  SearchHangoutsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/09.
//

import Foundation

import Foundation

struct SearchHangoutsResponseDTO: Decodable {
    
    let totalPage: Int
    let hangoutDTOs: [HangoutDTO]
    
    private enum CodingKeys: String, CodingKey {
        case totalPage
        case hangoutDTOs = "data"
    }
}

extension SearchHangoutsResponseDTO {
    struct HangoutDTO: Decodable {
        let id: String
        let state: String
        let title: String
        let meetTime: String
        let language: String
        let placeID: String
        let placeName: String
        let plan: String
        let limitNumber: Int
        let latitude: Double
        let longitude: Double
        let postImageFilename: String
        let openchatURL: String
        let mapImageFilename: String
        let participantIDs: [InfoDTO]
        let userHasLiked: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id = "hangoutId"
            case state = "hangoutState"
            case title = "hangoutTitle"
            case meetTime = "hangoutMeetTime"
            case language = "hangoutLanguage"
            case placeID = "hangoutPlaceId"
            case placeName = "hangoutPlaceName"
            case plan = "hangoutPlan"
            case limitNumber = "hangoutTotalNum"
            case latitude = "placeLatitude"
            case longitude = "placeLongitude"
            case postImageFilename = "hangoutImageUrl"
            case openchatURL = "hangoutOpenChat"
            case mapImageFilename = "placeImageUrl"
            case participantIDs = "participants"
            case userHasLiked = "like"
        }
    }
    
    struct InfoDTO: Decodable {
        let id: String
        let profileImageFilename: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "userId"
            case profileImageFilename = "userProfileImageUrl"
        }
    }
}


extension SearchHangoutsResponseDTO {
    func toDomain() -> HangoutPage {
        let hangouts = hangoutDTOs
            .map { element -> Hangout in
                var state: Hangout.State {
                    switch element.state {
                    case "available": return .available
                    case "closed": return .closed
                    default: return .expired }
                }
                
                let date = element.meetTime.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? Date()
                let coordinates = Coordinates(latitude: element.latitude, longitude: element.longitude)
                let postImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/\(element.postImageFilename)")
                let mapImageURL = URL(string: "\(BAPPY_API_BASEURL)static-file/\(element.mapImageFilename)")
                
                return Hangout(
                    id: element.id,
                    state: state,
                    title: element.title,
                    meetTime: date,
                    language: element.language,
                    placeID: element.placeID,
                    placeName: element.placeName,
                    plan: element.plan,
                    limitNumber: element.limitNumber,
                    coordinates: coordinates,
                    postImageURL: postImageURL,
                    openchatURL: URL(string: element.openchatURL),
                    mapImageURL: mapImageURL,
                    participantIDs: [],
                    userHasLiked: element.userHasLiked
                )
            }
        return HangoutPage(totalPage: totalPage, hangouts: hangouts)
    }
}

