//
//  HangoutCellHolderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/07.
//

import UIKit
import SnapKit

final class HangoutCellHolderView: UIView {
    
    // MARK: Properties
    private let transparentHolderView = UIView()
    private let titleHolderView = UIView()
    private let timeHolderView = UIView()
    private let placeHolderView = UIView()
    private let firstParticipantView = UIView()
    private let secondParticipantView = UIView()
    private let thirdParticipantView = UIView()
    private let buttonHolderView = UIView()
    
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
        let holderColor: UIColor = .rgb(232, 232, 225, 1)
        
        self.backgroundColor = .bappyLightgray
        self.clipsToBounds = true
        
        transparentHolderView.backgroundColor = holderColor.withAlphaComponent(0.3)
        transparentHolderView.layer.cornerRadius = 17.0
        
        titleHolderView.backgroundColor = holderColor
        titleHolderView.layer.cornerRadius = 3.0
        timeHolderView.backgroundColor = holderColor
        timeHolderView.layer.cornerRadius = 3.0
        placeHolderView.backgroundColor = holderColor
        placeHolderView.layer.cornerRadius = 3.0
        firstParticipantView.backgroundColor = holderColor
        firstParticipantView.layer.cornerRadius = 16.5
        secondParticipantView.backgroundColor = holderColor
        secondParticipantView.layer.cornerRadius = 16.5
        thirdParticipantView.backgroundColor = holderColor
        thirdParticipantView.layer.cornerRadius = 16.5
        buttonHolderView.backgroundColor = holderColor
        buttonHolderView.layer.cornerRadius = 4.0
    }
    
    private func layout() {
        let arrangedSubviews: [UIView] = [firstParticipantView, secondParticipantView, thirdParticipantView]
        let hStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        hStackView.axis = .horizontal
        hStackView.spacing = 10.0
        hStackView.distribution = .fillEqually
        
        self.snp.makeConstraints {
            $0.height.equalTo(self.snp.width).multipliedBy(333.0/390.0)
        }
        
        self.addSubview(transparentHolderView)
        transparentHolderView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(-153.0)
            $0.bottom.equalToSuperview().offset(19.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        transparentHolderView.addSubview(titleHolderView)
        titleHolderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(17.0)
            $0.trailing.equalToSuperview().inset(62.0)
            $0.height.equalTo(25.0)
        }
        
        transparentHolderView.addSubview(timeHolderView)
        timeHolderView.snp.makeConstraints {
            $0.top.equalTo(titleHolderView.snp.bottom).offset(9.0)
            $0.leading.equalTo(titleHolderView)
            $0.width.equalTo(157.0)
            $0.height.equalTo(18.0)
        }
        
        transparentHolderView.addSubview(placeHolderView)
        placeHolderView.snp.makeConstraints {
            $0.top.equalTo(timeHolderView.snp.bottom).offset(5.0)
            $0.leading.equalTo(titleHolderView)
            $0.width.equalTo(157.0)
            $0.height.equalTo(18.0)
        }
        
        transparentHolderView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(placeHolderView.snp.bottom).offset(9.0)
            $0.leading.equalToSuperview().inset(25.0)
            $0.width.equalTo(119.0)
            $0.height.equalTo(33.0)
        }
        
        transparentHolderView.addSubview(buttonHolderView)
        buttonHolderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(75.0)
            $0.trailing.equalToSuperview().inset(17.0)
            $0.width.equalTo(136.0)
            $0.height.equalTo(56.0)
        }
    }
}
