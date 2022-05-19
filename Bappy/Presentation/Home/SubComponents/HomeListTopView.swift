//
//  HomeListTopView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class HomeListTopView: UIView {
    
    // MARK: Properties
    private let localeSelctionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Busan",
                attributes: [
                    .font: UIFont.roboto(size: 24.0, family: .Medium),
                    .foregroundColor: UIColor(red: 86.0/255.0, green: 69.0/255.0, blue: 8.0/255.0, alpha: 1.0)
                ]),
            for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(localeSelctionButton)
        localeSelctionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(33.0)
        }
        
        let dividingView = UIView()
        dividingView.backgroundColor = .black.withAlphaComponent(0.25)
        
        self.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.top.equalTo(localeSelctionButton.snp.bottom).offset(23.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        let bottomSectionView = UIView()
        bottomSectionView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        self.addSubview(bottomSectionView)
        bottomSectionView.snp.makeConstraints {
            $0.top.equalTo(dividingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.0)
        }
    }
}
