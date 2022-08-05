//
//  BappyTabBar.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit

final class BappyTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = super.sizeThatFits(size).width
        let height = bottomInset / 3.0 + 76.0
        return CGSize(width: width, height: height)
    }
}
