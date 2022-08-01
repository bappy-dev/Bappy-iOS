//
//  BappyLikeButton.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import UIKit

final class BappyLikeButton: UIButton {
    
    // MARK: Properties
    override var isSelected: Bool {
        didSet { configure() }
    }
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        let image = isSelected ? UIImage(named: "heart_fill") : UIImage(named: "heart")
        self.setImage(image, for: .normal)
    }
}
