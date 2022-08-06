//
//  ProfileHangoutHolderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/06.
//

import UIKit
import SnapKit

final class ProfileHangoutHolderView: UIView {
    
    // MARK: Properties
    private let firstCellHolderView = ProfileHangoutCellHolderView()
    private let secondCellHolderView = ProfileHangoutCellHolderView()
    private let thirdCellHolderView = ProfileHangoutCellHolderView()
    private let fourthCellHolderView = ProfileHangoutCellHolderView()
    
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
        self.backgroundColor = .bappyLightgray
        
    }
    
    private func layout() {
        let arrangedSubviews: [UIView] = [
            firstCellHolderView,
            secondCellHolderView,
            thirdCellHolderView,
            fourthCellHolderView
        ]
        
        let vStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        vStackView.axis = .vertical
        vStackView.spacing = 18.0
        vStackView.distribution = .fillEqually
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.trailing.equalToSuperview().inset(13.0)
        }
    }
}
