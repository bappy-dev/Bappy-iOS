//
//  SelectionButton.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectionButton: UIButton {
    
    // MARK: Properties
    let title: String
    var font: UIFont = .roboto(size: 16.0, family: .Medium)
    
    // MARK: Lifecycle
    init(title: String, isSmall: Bool = false) {
        self.title = title
        
        super.init(frame: .zero)
        configure(isSmall)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure(_ isSmall: Bool) {
        self.layer.cornerRadius = 3.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        // 임시
        self.setBappyTitle(
            title: title,
            font: .roboto(size: isSmall ? 14.0 : 16.0, family: .Medium),
            color: .bappyGray
        )
        self.backgroundColor = .bappyLightgray
        self.clipsToBounds = true
    }
    
    func off() {
        isSelected = false
        setBappyTitle(
            title: title,
            font: font,
            color: .bappyGray
        )
        backgroundColor = .bappyLightgray
        clipsToBounds = true
    }
}

// MARK: - Binder
extension Reactive where Base: SelectionButton {
    var isSelected: Binder<Bool> {
        return Binder(self.base) { button, isSelected in
            if isSelected {
                button.setBappyTitle(
                    title: base.title,
                    font: base.font
                )
                button.backgroundColor = .bappyYellow
                button.clipsToBounds = false
            } else {
                button.setBappyTitle(
                    title: base.title,
                    font: base.font,
                    color: .bappyGray
                )
                button.backgroundColor = .bappyLightgray
                button.clipsToBounds = true
            }
        }
    }
}
