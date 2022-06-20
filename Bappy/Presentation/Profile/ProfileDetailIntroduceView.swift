//
//  ProfileDetailIntroduceView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

final class ProfileDetailIntroduceView: UIView {
    
    // MARK: Properties
    private let introduceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_introduce")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "About me"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let introduceTextView: UITextView = {
        let textView = UITextView()
        textView.font = .roboto(size: 12.0, family: .Regular)
        textView.textColor = .bappyBrown
        textView.textAlignment = .justified
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
        introduceTextView.text = "I love coffee."
    }
    
    private func layout() {
        self.addSubview(introduceImageView)
        introduceImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11.0)
            $0.leading.equalToSuperview().inset(64.0)
            $0.width.height.equalTo(20.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(introduceImageView.snp.trailing).offset(6.0)
            $0.centerY.equalTo(introduceImageView)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(introduceImageView.snp.bottom).offset(9.0)
            $0.leading.equalToSuperview().inset(59.0)
            $0.trailing.equalToSuperview().inset(58.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        backgroundView.addSubview(introduceTextView)
        introduceTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
    }
}
