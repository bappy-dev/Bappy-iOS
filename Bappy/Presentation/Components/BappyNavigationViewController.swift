//
//
//  BappyNavigationViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit

final class BappyNavigationViewController: UINavigationController {
    var statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
