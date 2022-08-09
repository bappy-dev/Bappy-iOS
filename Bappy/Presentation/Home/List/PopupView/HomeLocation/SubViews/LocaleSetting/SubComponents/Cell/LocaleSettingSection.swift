//
//  LocaleSettingSection.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/12.
//

import Foundation
import RxDataSources

struct LocaleSettingSection {
    var items: [Item]
    var identity: String
    
    init(items: [Item]) {
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension LocaleSettingSection: AnimatableSectionModelType {
    typealias Item = Location
    
    init(original: LocaleSettingSection, items: [Location]) {
        self = original
        self.items = items
    }
}
