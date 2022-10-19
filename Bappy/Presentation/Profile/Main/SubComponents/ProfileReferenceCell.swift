//
//  ProfileReferenceCell.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/19.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileReferenceCell: UITableViewCell {
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Regular)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Medium)
        label.textColor = .bappyYellow
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Regular)
        label.textColor = .bappyGray
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 10.0, family: .Regular)
        label.textColor = .bappyGray
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let frameView = UIView()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        frameView.backgroundColor = .white
        frameView.layer.cornerRadius = 9.0
        frameView.clipsToBounds = true
    }
    
    private func layout() {
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.trailing.equalToSuperview().inset(13.0)
        }
        
        frameView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.leading.equalToSuperview().inset(10.0)
            $0.width.height.equalTo(50.0)
        }
        
        frameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(7.0)
        }
        
        frameView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
        }
        
        frameView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
        }
        
        frameView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(21.0)
        }
        
    }
}

// MARK: - Bind
extension ProfileReferenceCell {
    func bind(with reference: Reference) {
        profileImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "no_profile_l"))
        nameLabel.text = "Good"
        titleLabel.text = "Want to meet again"
        dateLabel.text = "2022-22-22"
        contentLabel.text = reference.contents
    }
}
