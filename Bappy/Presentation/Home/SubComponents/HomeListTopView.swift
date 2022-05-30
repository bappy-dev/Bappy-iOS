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
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Busan",
                attributes: [
                    .font: UIFont.roboto(size: 24.0, family: .Medium),
                    .foregroundColor: UIColor(named: "bappy_brown")!
                ]),
            for: .normal)
        return button
    }()
    
    private let languageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_language"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_date"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    private let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_write"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_search"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    private let contentView = UIView()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.addBappyShadow(shadowOffsetHeight: 1.0)
    }
    
    private func layout() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2.0)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [
            languageButton, dateButton, writeButton, searchButton
        ])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        
        contentView.addSubview(localeSelctionButton)
        localeSelctionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.height.equalTo(44.0)
            $0.leading.equalToSuperview().inset(33.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.width.equalTo(140.0)
            $0.height.equalTo(35.0)
            $0.centerY.equalTo(localeSelctionButton)
            $0.trailing.equalToSuperview().inset(9.5)
        }
        
        let localeButtonImage = UIImage(systemName: "arrowtriangle.down.fill")
        let localeButtonImageView = UIImageView(image: localeButtonImage)
        localeButtonImageView.tintColor = UIColor(named: "bappy_brown")
        localeSelctionButton.addSubview(localeButtonImageView)
        localeButtonImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12.0)
            $0.width.height.equalTo(12.0)
            $0.trailing.equalToSuperview().inset(-16.0)
        }
    }
}
