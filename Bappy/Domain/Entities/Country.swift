//
//  Country.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/13.
//

import UIKit

struct Country {
    let code: String
    let name: String
    var flag: String {
        let base : UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
