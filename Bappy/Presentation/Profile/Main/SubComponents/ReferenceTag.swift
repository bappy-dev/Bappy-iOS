//
//  ReferenceTag.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/20.
//

import UIKit

class ReferenceTag: UIView {
    var tagWidth: CGFloat = 0.0
    
    init(tag: String) {
        super.init(frame: .zero)
        
        let label = UILabel()
        label.text = tag
        label.textColor = .bappyBrown
        label.font = .roboto(size: 14.0, family: .Bold)
        
        backgroundColor = .bappyYellow.withAlphaComponent(0.5)
        layer.cornerRadius = 19.5
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12.0)
        }
        
        tagWidth = label.intrinsicContentSize.width + 24.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
