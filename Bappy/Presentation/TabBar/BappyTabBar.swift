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
        
        return CGSize(width: width, height: 89.0)
    }
}
