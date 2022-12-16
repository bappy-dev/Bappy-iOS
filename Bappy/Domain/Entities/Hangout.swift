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
    
    let postImageURL: URL?
    let openchatURL: String
    
    var joinedIDs: [Info]
    var likedIDs: [Info]
    var userHasLiked: Bool
    var isUpdate: Bool
    
    static func == (lhs: Hangout, rhs: Hangout) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Hangout {
    struct Info {
        let id: String
        let imageURL: URL?
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
    
    enum State: String { case available, closed, expired, preview, edit, save }
    
    enum Category: Int, CaseIterable {
        case ALL, Travel, Eat_out, Cafe, Cooking, Vegan, Bar, Language, Discussion, Dance, KPOP, Study, Read, Instruments, Draw, Movie, Exhibition, Museum, Festival, Concerts, Party, Picnic, Boardgame, Sports, Volunteer, Projcets, Career
        
        var description: String {
            switch self {
            case .ALL : return "ALL"
            case .Travel : return "Travel"
            case .Eat_out: return "Eat out"
            case .Cafe : return "Cafe"
            case .Cooking : return "Cooking"
            case .Vegan: return "Vegan"
            case .Bar : return "Bar"
            case .Language : return "Language Practice"
            case .Discussion : return "Discussion"
            case .Dance : return "Dance"
            case .KPOP : return "K-POP"
            case .Study : return "Study"
            case .Read: return "Read"
            case .Instruments: return "Instruments"
            case .Draw: return "Draw"
            case .Movie: return "Movie"
            case .Exhibition: return "Exhibition"
            case .Museum: return "Museum"
            case .Festival: return "Festival"
            case .Concerts: return "Concerts"
            case .Party: return "Party"
            case .Picnic: return "Picnic"
            case .Boardgame: return "Boardgame"
            case .Sports: return "Sports"
            case .Volunteer : return "Volunteer"
            case .Projcets: return "Projcets"
            case .Career: return "Career"
            }
        }
        
        static func makeCategory(with string: String) -> Hangout.Category? {
            switch string {
            case "Travel": return .Travel
            case "Eat out": return .Eat_out
            case "Cafe": return .Cafe
            case "Cooking": return .Cooking
            case "Vegan": return .Vegan
            case "Bar": return .Bar
            case "Language Practice": return .Language
            case "Discussion": return .Discussion
            case "Dance": return .Dance
            case "K-POP": return .KPOP
            case "Study": return .Study
            case "Read": return .Read
            case "Instruments": return .Instruments
            case "Draw": return .Draw
            case "Movie": return .Movie
            case "Exhibition": return .Exhibition
            case "Museum": return .Museum
            case "Festival": return .Festival
            case "Concerts": return .Concerts
            case "Party": return .Party
            case "Picnic": return .Picnic
            case "Boardgame": return .Boardgame
            case "Sports": return .Sports
            case "Volunteer": return .Volunteer
            case "Projcets": return .Projcets
            case "Career": return .Career
            default: return nil }
        }
    }
    
    enum SortingOrder: Int, CaseIterable {
        case Newest, Nearest, MostViews, MostHearts, Lessseats
        
        var description: String {
            switch self {
            case .Newest: return "Newest"
            case .Nearest: return "Nearest"
            case .MostViews: return "Most views"
            case .MostHearts: return "Most Likes"
            case .Lessseats: return "Less seats"
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
