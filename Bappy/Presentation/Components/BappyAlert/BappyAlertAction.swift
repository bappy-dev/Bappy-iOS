//
//  BappyAlertAction.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/14.
//

import UIKit

final class BappyAlertAction {
    enum Style { case `default`, cancel }
    
    var title: String
    var style: Style
    var handler: ((BappyAlertAction) -> Void)?
    
    init(title: String, style: Style, handler: ((BappyAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
