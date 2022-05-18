//
//  Extension.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import RxSwift

extension UIFont {
    enum Family: String {
        case Black, Bold, Light, Medium, Regular, Thin
    }
    
    static func roboto(size: CGFloat, family: Family = .Regular) -> UIFont {
        return UIFont(name: "Roboto-\(family)", size: size)!
    }
}

//extension Reactive where Base: UIView {
//    var endEditing: Binder<Void> {
//        return Binder(self.base) { view, _ in
//            view.endEditing(true)
//        }
//    }
//}
