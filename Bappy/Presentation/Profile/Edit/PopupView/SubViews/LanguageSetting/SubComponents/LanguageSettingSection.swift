//
//  LanguageSettingSection.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/02.
//

import Foundation
import RxDataSources

struct LanguageSettingSection {
    var items: [Item]
    var identity: String
    
    init(items: [Item]) {
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension LanguageSettingSection: AnimatableSectionModelType {
    typealias Item = Language
    
    init(original: LanguageSettingSection, items: [Language]) {
        self = original
        self.items = items
    }
}
