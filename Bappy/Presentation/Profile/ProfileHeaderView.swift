//
//  ProfileHeaderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func moreButtonDidTap()
}

final class ProfileHeaderView: UIView {
    
    // MARK: Properties
    weak var delegate: ProfileHeaderViewDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_profile_l")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 45.5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Jessica"
        return label
    }()
    
    private let flagLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "🇺🇸"
        return label
    }()
    
    private let genderAndBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 16.0)
        label.textColor = .bappyBrown
        label.text = "Female / 2007.07.27"
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profile_more"), for: .normal)
        button.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        return button
    }()
    
    private let buttonSectionView = ProfileButtonSectionView()
    
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
    private func didTapProfileButton() {
        delegate?.moreButtonDidTap()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58.0)
            $0.width.height.equalTo(91.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(11.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(flagLabel)
        flagLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(3.0)
        }
        
        self.addSubview(genderAndBirthLabel)
        genderAndBirthLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.centerY.equalTo(genderAndBirthLabel)
            $0.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(34.0)
        }

        self.addSubview(buttonSectionView)
        buttonSectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
