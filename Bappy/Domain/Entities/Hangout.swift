//
//  Hangout.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/22.
//

import UIKit

enum HangoutState: String { case available, closed, expired, preview }

struct Hangout: Equatable, Identifiable {
    typealias Identifier = String
    typealias Info = (id: String, imageURL: URL?)
    
    let id: Identifier
    let state: HangoutState
    
    let title: String
    let meetTime: String
    let language: Language
    let placeName: String
    let plan: String
    let limitNumber: Int
    
    let latitude: CGFloat //
    let longitude: CGFloat //
    
    let postImageURL: URL?
    let openchatURL: URL?
    let mapImageURL: URL?
    let googleMapURL: URL?
    let kakaoMapURL: URL?
    
    let participantIDs: [Info]
    let userHasLiked: Bool
    
    static func == (lhs: Hangout, rhs: Hangout) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HangoutPage: Equatable {
    let totalPage: Int
    let hangouts: [Hangout]
}
