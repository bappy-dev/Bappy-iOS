//
//  HangoutCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class HangoutCell: UITableViewCell {
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_profile_s")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11.5
        return imageView
    }()
    
    private let nameAndFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Jessica 🇺🇸"
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "example_post.png")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 9
        label.numberOfLines = 4
        label.attributedText = NSAttributedString(
            string: "TITLE\nTIME\nPLACE\nJOIN",
            attributes: [
                .foregroundColor: UIColor(named: "bappy_brown")!,
                .font: UIFont.roboto(size: 14.0, family: .Medium),
                .paragraphStyle: paragraphStyle
            ])
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "#Korean #Restaurant #PNU #Yummy"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "03. Mar. 19:00"
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "PNU"
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setImage(UIImage(named: "heart_fill"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 15.6, left: 14.5, bottom: 15.6, right: 14.5)
        button.addTarget(self, action: #selector(toggleHeartButton), for: .touchUpInside)
        return button
    }()
    
    private let postingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 10.0, family: .Light)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "6 hours ago"
        return label
    }()
    
    private let participantsView = ParticipantsView()
    
    private let postView = UIView()
    
    // MARK: Lifecycle    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func toggleHeartButton(button: UIButton) {
        button.isSelected = !button.isSelected
        let normalImage = button.isSelected ? UIImage(named: "heart_fill") : UIImage(named: "heart")
        button.setImage(normalImage, for: .normal)
    }
    
    // MARK: Helpers
    private func configure() {
        contentView.backgroundColor = UIColor(named: "bappy_lightgray")
        postView.backgroundColor = .white
        postView.clipsToBounds = false
        postView.layer.shadowColor = UIColor.black.cgColor
        postView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        postView.layer.shadowOpacity = 0.25
        postView.layer.shadowRadius = 1.0
    }
    
    private func layout() {
        contentView.addSubview(postView)
        postView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(17.0)
        }
        
        postView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(11.0)
            $0.width.height.equalTo(23.0)
        }
        
        postView.addSubview(nameAndFlagLabel)
        nameAndFlagLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13.0)
            $0.centerY.equalTo(profileImageView)
        }
        
        postView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(9.0/16.0)
        }
        
        postView.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(15.0)
        }
        
        postView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(15.0)
            $0.leading.equalTo(captionLabel.snp.trailing).offset(10.0)
        }
        
        postView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11.2)
            $0.leading.equalTo(titleLabel)
        }
        
        postView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(11.2)
            $0.leading.equalTo(titleLabel)
        }
        
        postView.addSubview(heartButton)
        heartButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
        
        postView.addSubview(postingTimeLabel)
        postingTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalTo(captionLabel).offset(-3.0)
        }
        
        postView.addSubview(participantsView)
        participantsView.snp.makeConstraints {
            $0.bottom.equalTo(captionLabel)
            $0.height.equalTo(18.0)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(postingTimeLabel.snp.leading).offset(-10.0)
        }
    }
}
