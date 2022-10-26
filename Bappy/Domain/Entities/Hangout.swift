//
//  Hangout.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/22.
//

import Foundation

struct Hangout: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let state: State
    
    let title: String
    let meetTime: Date
    let language: Language
    let plan: String
    let limitNumber: Int
    let categories: [Category]
    let place: Place
    
    let postImageURL: URL
    let openchatURL: URL
    
    let joinedIDs: [Info]
    let likedIDs: [Info]
    var userHasLiked: Bool
    
    static func == (lhs: Hangout, rhs: Hangout) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Hangout {
    struct Info {
        let id: String
        let imageURL: URL
    }
    
    struct Place {
        let name: String
        let address: String
        let coordinates: Coordinates
        
        init(name: String, address: String, latitude: Double, longitude: Double) {
            self.name = name
            self.address = address
            self.coordinates = Coordinates(latitude: latitude, longitude: longitude)
        }
    }
    
    enum State: String { case available, closed, expired, preview }
    
    enum Category: Int {
        case ALL, Travel, Cafe, Hiking, Food, Bar, Cook, Shopping, Volunteer, Language, Crafting, BallGame, Running, Concerts, Museum, Vegan, Boardgame, Music
        
        var description: String {
            switch self {
            case .ALL : return "ALL"
            case .Travel : return "Travel"
            case .Cafe : return "Cafe"
            case .Hiking : return "Hiking"
            case .Food : return "Food"
            case .Bar : return "Bar"
            case .Cook : return "Cook"
            case .Shopping : return "Shopping"
            case .Volunteer : return "Volunteer"
            case .Language : return "Practice Language"
            case .Crafting : return "Crafting"
            case .BallGame: return "BallGame"
            case .Running: return "Running"
            case .Concerts: return "Concerts"
            case .Museum: return "Museum"
            case .Music: return "Music"
            case .Vegan: return "Vegan"
            case .Boardgame: return "Boardgame"
            }
        }
    }
    
    enum SortingOrder: Int {
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
    
    enum UserProfileType: Int {
        case Joined, Made, Liked
        
        var description: String {
            switch self {
            case .Joined: return "join"
            case .Made: return "made"
            case .Liked: return "like"
            }
        }
    }
}

struct HangoutPage: Equatable {
    let totalPage: Int
    let hangouts: [Hangout]
}
