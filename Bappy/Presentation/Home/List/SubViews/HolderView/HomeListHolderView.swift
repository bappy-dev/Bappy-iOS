//
//  HomeListHolderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/07.
//

import UIKit
import SnapKit

final class HomeListHolderView: UIView {
    
    // MARK: Properties
    private let firstCellHolderView = HangoutCellHolderView()
    private let secondCellHolderView = HangoutCellHolderView()
    private let thirdCellHolderView = HangoutCellHolderView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        
    }
    
    private func layout() {
        let arrangedSubviews: [UIView] = [
            firstCellHolderView,
            secondCellHolderView,
            thirdCellHolderView
        ]
        
        let vStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        vStackView.axis = .vertical
        vStackView.spacing = 11.0
        vStackView.distribution = .fillEqually
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
