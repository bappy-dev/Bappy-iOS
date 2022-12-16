//
//  ScreenUtil.swift
//  Bappy
//
//  Created by 이현욱 on 2022/12/08.
//

import UIKit

struct ScreenUtil {
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var statusBarHeight: CGFloat {
        //        apple bug iphone 12 mini 50
        return UIApplication.statusBarHeight
    }
    
    static var bounds: CGRect {
        return UIScreen.main.bounds
    }
    
    static var safeAreaTop: CGFloat {
        return UIWindow.keyWindow?.safeAreaInsets.top ?? 0
    }
    
    static var safeAreaBottom: CGFloat {
        return UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}
