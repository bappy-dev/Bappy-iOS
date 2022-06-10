//
//  BappyScrollView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/07.
//

import UIKit

final class BappyScrollView: UIScrollView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTargetView = super.hitTest(point, with: event)
        return hitTargetView as? UIControl ?? (hitTargetView == self ? nil : superview)
    }
    
    override func didMoveToSuperview() {
        superview?.addGestureRecognizer(panGestureRecognizer)
    }
}
