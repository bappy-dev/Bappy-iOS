//
//  ProfileDetailLanguageView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

final class ProfileDetailLanguageView: UIView {
    
    // MARK: Properties
    private let languageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_language")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Speaking Languages"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let languageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .roboto(size: 12.0, family: .Regular)
        textView.textColor = .bappyBrown
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let backgroundView = UIView()
    
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
        backgroundView.backgroundColor = .bappyLightgray
        backgroundView.layer.cornerRadius = 11.0
        languageTextView.text = "Korean / English / Spanish"
    }
    
    private func layout() {
        self.addSubview(languageImageView)
        languageImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.0)
            $0.leading.equalToSuperview().inset(66.0)
            $0.width.height.equalTo(18.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(languageImageView.snp.trailing).offset(6.0)
            $0.centerY.equalTo(languageImageView)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(languageImageView.snp.bottom).offset(9.0)
            $0.leading.equalToSuperview().inset(59.0)
            $0.trailing.equalToSuperview().inset(58.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        backgroundView.addSubview(languageTextView)
        languageTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
    }
}
