//
//  HomeListTopView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

protocol HomeListTopViewDelegate: AnyObject {
    func showDateFilterView()
    func showWriteView()
}

final class HomeListTopView: UIView {
    
    // MARK: Properties
    weak var delegate: HomeListTopViewDelegate?
    
    private let localeSelctionButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Busan",
                attributes: [
                    .font: UIFont.roboto(size: 32.0, family: .Medium),
                    .foregroundColor: UIColor(named: "bappy_brown")!
                ]), for: .normal)
        return button
    }()
    
    private let languageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_language"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_search"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_date"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.addTarget(self, action: #selector(dateButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_write"), for: .normal)
        button.imageEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.addTarget(self, action: #selector(writeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func dateButtonHandler() {
        delegate?.showDateFilterView()
    }
    
    @objc
    private func writeButtonHandler() {
        delegate?.showWriteView()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        let buttonStackView = UIStackView(arrangedSubviews: [
            searchButton, dateButton, writeButton
        ])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 1.5
        
        let localeButtonImage = UIImage(systemName: "arrowtriangle.down.fill")
        let localeButtonImageView = UIImageView(image: localeButtonImage)
        localeButtonImageView.tintColor = UIColor(named: "bappy_yellow")
        localeButtonImageView.contentMode = .scaleToFill
        
        self.addSubview(localeSelctionButton)
        localeSelctionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.height.equalTo(44.0)
            $0.leading.equalToSuperview().inset(19.0)
            $0.bottom.equalToSuperview().inset(12.0)
        }
        
        localeSelctionButton.addSubview(localeButtonImageView)
        localeButtonImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8.5)
            $0.width.equalTo(16.0)
            $0.height.equalTo(13.0)
            $0.trailing.equalToSuperview().inset(-30.0)
        }
        
        self.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.width.equalTo(123.0)
            $0.height.equalTo(40.0)
            $0.centerY.equalTo(localeSelctionButton)
            $0.trailing.equalToSuperview().inset(20.5)
        }
    }
}
