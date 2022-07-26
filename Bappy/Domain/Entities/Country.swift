//
//  Country.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/13.
//

import UIKit

struct Country {
    let code: String
    var name: String {
        NSLocale(localeIdentifier: "en_UK")
            .displayName(forKey: NSLocale.Key.identifier, value: "_\(code)") ?? ""
    }
    var flag: String { code.toFlag() }
}
