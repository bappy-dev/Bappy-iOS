//
//  Profile.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import Foundation


struct Profile {
    
    let user: BappyUser
    
    let joinedHangouts: [Hangout]
    let madeHangouts: [Hangout]
    let likedHangouts: [Hangout]
}
