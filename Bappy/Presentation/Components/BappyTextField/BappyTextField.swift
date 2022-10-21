//
//  BappyTextField.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit

class BappyTextField: UITextField {
    let padding = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    init() {
        super.init(frame: .zero)
        
        font = .roboto(size: 14.0, family: .Bold)
        textColor = .bappyGray
        backgroundColor = .bappyLightgray
        layer.cornerRadius = 19.5
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
