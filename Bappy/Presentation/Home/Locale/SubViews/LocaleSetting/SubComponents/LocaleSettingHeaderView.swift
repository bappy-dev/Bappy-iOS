//
//  LocaleSettingHeaderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import UIKit
import SnapKit
import CryptoKit

final class LocaleSettingHeaderView: UIView {
    
    // MARK: Properties
    private let currentLocaleButton = UIButton()
    
    private let currentLocaleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_set_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Set to Current Location"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Medium)
        return label
    }()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locale_selected")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        self.backgroundColor = .clear
        currentLocaleButton.backgroundColor = .white
        selectedImageView.isHidden = true
    }
    
    private func layout() {
        let topSeparatorView = UIView()
        let bottomSeparatorView = UIView()
        topSeparatorView.backgroundColor = .black.withAlphaComponent(0.2)
        bottomSeparatorView.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.addSubview(currentLocaleButton)
        currentLocaleButton.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalTo(60.0)
        }
        
        currentLocaleButton.addSubview(currentLocaleImageView)
        currentLocaleImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22.0)
        }
        
        currentLocaleButton.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(currentLocaleImageView.snp.trailing).offset(15.0)
            $0.centerY.equalToSuperview()
        }
        
        currentLocaleButton.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25.0)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(18.0)
            $0.height.equalTo(14.0)
        }
        
        self.addSubview(topSeparatorView)
        topSeparatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(currentLocaleButton.snp.top)
            $0.height.equalTo(1.0/3.0)
        }
        
        self.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints {
            $0.top.equalTo(currentLocaleButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0/3.0)
        }
    }
}
