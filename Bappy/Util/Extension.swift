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

extension UIImage {
    func downSize(newWidth: CGFloat) -> UIImage {
        guard newWidth < self.size.width else { return self }
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("DEBUG: Data size ->", renderImage)
        return renderImage
    }
}
