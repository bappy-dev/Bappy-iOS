//
//  ProfileHangoutCellHolderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/06.
//

import UIKit
import SnapKit

final class ProfileHangoutCellHolderView: UIView {
    
    // MARK: Properties
    private let imageHolderView = UIView()
    private let titleHolderView = UIView()
    private let timeHolderView = UIView()
    private let placeHolderView = UIView()
    private let firstParticipantView = UIView()
    private let secondParticipantView = UIView()
    private let thirdParticipantView = UIView()
    
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
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        let holderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        imageHolderView.backgroundColor = holderColor
        imageHolderView.layer.cornerRadius = 9.0
        titleHolderView.backgroundColor = holderColor
        titleHolderView.layer.cornerRadius = 3.0
        timeHolderView.backgroundColor = holderColor
        timeHolderView.layer.cornerRadius = 3.0
        placeHolderView.backgroundColor = holderColor
        placeHolderView.layer.cornerRadius = 3.0
        firstParticipantView.backgroundColor = holderColor
        firstParticipantView.layer.cornerRadius = 12.5
        secondParticipantView.backgroundColor = holderColor
        secondParticipantView.layer.cornerRadius = 12.5
        thirdParticipantView.backgroundColor = holderColor
        thirdParticipantView.layer.cornerRadius = 12.5
    }
    
    private func layout() {
        let arrangedSubviews: [UIView] = [firstParticipantView, secondParticipantView, thirdParticipantView]
        let hStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        hStackView.axis = .horizontal
        hStackView.spacing = 11.0
        hStackView.distribution = .fillEqually
        
        self.snp.makeConstraints {
            $0.height.equalTo(139.0)
        }
        
        self.addSubview(imageHolderView)
        imageHolderView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(11.0)
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.equalTo(116.0)
            $0.height.equalTo(117.0)
        }
        
        self.addSubview(titleHolderView)
        titleHolderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.0)
            $0.leading.equalTo(imageHolderView.snp.trailing).offset(12.0)
            $0.trailing.equalToSuperview().inset(14.0)
            $0.height.equalTo(18.0)
        }
        
        self.addSubview(timeHolderView)
        timeHolderView.snp.makeConstraints {
            $0.top.equalTo(titleHolderView.snp.bottom).offset(17.0)
            $0.leading.equalTo(titleHolderView)
            $0.width.equalTo(129.0)
            $0.height.equalTo(12.0)
        }
        
        self.addSubview(placeHolderView)
        placeHolderView.snp.makeConstraints {
            $0.top.equalTo(timeHolderView.snp.bottom).offset(8.0)
            $0.leading.equalTo(titleHolderView)
            $0.width.equalTo(129.0)
            $0.height.equalTo(12.0)
        }
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(placeHolderView.snp.bottom).offset(10.0)
            $0.leading.equalTo(imageHolderView.snp.trailing).offset(16.0)
            $0.width.equalTo(97.0)
            $0.height.equalTo(25.0)
        }
    }
}
