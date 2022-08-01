//
//  SelectionLabel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectionLabel: UILabel {
    
    // MARK: Properties
    let title: String
    
    // MARK: Lifecycle
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.text = title
        self.textColor = .bappyBrown
        self.font = .roboto(size: 14.0)
        self.backgroundColor = .bappyLightgray
        self.textAlignment = .center
        self.clipsToBounds = true
    }
}

// MARK: - Binder
extension Reactive where Base: SelectionLabel {
    var isSelected: Binder<Bool> {
        return Binder(self.base) { label, isSelected in
            label.backgroundColor = isSelected ? .bappyYellow : .bappyLightgray
        }
    }
}
