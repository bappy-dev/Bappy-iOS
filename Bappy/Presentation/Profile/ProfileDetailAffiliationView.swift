//
//  ProfileDetailAffiliationView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

final class ProfileDetailAffiliationView: UIView {
    
    // MARK: Properties
    private let affiliationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_affiliation")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "University/Company"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let affiliationTextView: UITextView = {
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
        affiliationTextView.text = "I am in PNU!"
    }
    
    private func layout() {
        self.addSubview(affiliationImageView)
        affiliationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(66.0)
            $0.width.equalTo(23.0)
            $0.height.equalTo(14.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(affiliationImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(affiliationImageView)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(affiliationImageView.snp.bottom).offset(9.0)
            $0.leading.equalToSuperview().inset(59.0)
            $0.trailing.equalToSuperview().inset(58.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        backgroundView.addSubview(affiliationTextView)
        affiliationTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
    }
}
