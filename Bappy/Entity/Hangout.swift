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
    
    let title: String
    let meetTime: String
    let language: Language
    let placeName: String
    let plan: String
    let limitNumber: Int
    
    let latitude: CGFloat
    let longitude: CGFloat
    
    let postImageURL: URL?
    let openchatURL: URL?
    let mapImageURL: URL?
    let googleMapURL: URL?
    let kakaoMapURL: URL?
    
    let participantIDs: [String]
}

struct HangoutPage: Equatable {
    let totalPage: Int
    let hangouts: [Hangout]
}
