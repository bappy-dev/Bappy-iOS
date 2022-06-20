//
//  ProfileDetailMainView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

final class ProfileDetailMainView: UIView {
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_default")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 29.5
        return imageView
    }()
    
    private let nameAndFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 16.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Jessica 🇺🇸"
        return label
    }()
    
    private let genderAndBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 13.0)
        label.textColor = .bappyBrown
        label.text = "Female / 2007.07.27"
        return label
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
        self.backgroundColor = .white
    }
    
    private func layout() { 
        let vStackView = UIStackView(arrangedSubviews: [nameAndFlagLabel, genderAndBirthLabel])
        vStackView.axis = .vertical
        vStackView.spacing = 3.0
        vStackView.alignment = .center
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.0)
            $0.leading.equalToSuperview().inset(64.0)
            $0.width.height.equalTo(59.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(24.0)
            $0.centerY.equalTo(profileImageView)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
    }
}
