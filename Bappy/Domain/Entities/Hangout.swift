//
//  Hangout.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/22.
//

import UIKit

struct Hangout: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let state: State
    
    let title: String
    let meetTime: String
    let language: Language
    let placeID: String
    let placeName: String
    let plan: String
    let limitNumber: Int
    
    let coordinates: Coordinates
    
    let postImageURL: URL?
    let openchatURL: URL?
    let mapImageURL: URL?
    
    let participantIDs: [Info]
    var userHasLiked: Bool
    
    var googleMapURL: URL? {
        let baseURL = "https://www.google.com/maps/dir/"
        let path = "?"
        let queries = [
            "api=1",
            "destination=\(placeName)",
            "destination_place_id=\(placeID)"
        ]
        let urlString = baseURL + path + queries.joined(separator: "&")
        return urlString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap { URL(string: $0) }
    }
    
    var kakaoMapURL: URL? {
        let baseURL = "https://map.kakao.com/link/to/"
        let query = "\(placeName),\(coordinates.latitude),\(coordinates.longitude)"
        let urlString = baseURL + query
        return urlString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap { URL(string: $0) }
    }
    
    static func == (lhs: Hangout, rhs: Hangout) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Hangout {
    struct Info {
        let id: String
        let imageURL: URL?
    }
    
    enum State: String { case available, closed, expired, preview }
    enum Category: Int {
        case All, Travel, Study, Sports, Food, Drinks, Cook, Culture, Volunteer, Language, Crafting
        
        var description: String {
            switch self {
            case .All : return "All"
            case .Travel : return "Travel"
            case .Study : return "Study"
            case .Sports : return "Sports"
            case .Food : return "Food"
            case .Drinks : return "Drinks"
            case .Cook : return "Cook"
            case .Culture : return "Cultural Activities"
            case .Volunteer : return "Volunteer"
            case .Language : return "Practice Language"
            case .Crafting : return "Crafting"
            }
        }
    }
    enum Sorting: Int {
        case Newest, Nearest, ManyViews, manyHearts, lessSeats
        
        var description: String {
            switch self {
            case .Newest: return "Newest"
            case .Nearest: return "Nearest"
            case .ManyViews: return "Many views"
            case .manyHearts: return "Many hearts"
            case .lessSeats: return "Less seats"
            }
        }
    }
}

struct HangoutPage: Equatable {
    let totalPage: Int
    let hangouts: [Hangout]
}
