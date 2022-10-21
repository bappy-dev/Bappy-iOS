//
//  Reference.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/19.
//

import Foundation

struct Reference {
    var writerName: String
    var writerProfileImageURL: URL?
    var tags: [String]
    var contents: String
    var date: String
    var isCanRead: Bool
    var hangoutID: String
    
    
    enum Tag: Int {
        case Again, Friendly, Respectful, Talkative, Punctual, Rude, NotAgain, DidntMeet
        
        var description: String {
            switch self {
            case .Again:
                return "Again!"
            case .Friendly:
                return "Friendly"
            case .Respectful:
                return "Respectful"
            case .Talkative:
                return "Talkative"
            case .Punctual:
                return "Punctual"
            case .Rude:
                return "Rude"
            case .NotAgain:
                return "Not again"
            case .DidntMeet:
                return "Didn't meet"
            }
        }
    }
    
}
