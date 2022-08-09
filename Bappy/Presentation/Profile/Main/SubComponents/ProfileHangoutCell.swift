//
//  ProfileHangoutCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/12.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileHangoutCell: UITableViewCell {
    
    // MARK: Properties
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 9.0
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = .bappyBrown
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_date")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Medium)
        label.textColor = .bappyBrown
        label.lineBreakMode = .byTruncatingTail
        label.text = "03. Mar. 19:00"
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Medium)
        label.textColor = .bappyBrown
        label.lineBreakMode = .byTruncatingTail
        label.text = "Pusan University"
        return label
    }()
    
    private let participantsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_participants")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let disabledView: UIView = {
        let disabledView = UIView()
        disabledView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        return disabledView
    }()
    
    private let disabledImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
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
        
        postImageView.kf.setImage(with: URL(string: EXAMPLE_IMAGE3_URL))
    }
    
    private func layout() {
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.trailing.equalToSuperview().inset(13.0)
        }
        
        frameView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.equalTo(116.0)
            $0.height.equalTo(117.0)
        }
        
        frameView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.leading.equalTo(postImageView.snp.trailing).offset(6.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(9.0)
        }
        
        frameView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3.0)
            $0.leading.equalTo(postImageView.snp.trailing).offset(33.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(9.0)
        }
        
        frameView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(timeLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(9.0)
        }
        
        frameView.addSubview(timeImageView)
        timeImageView.snp.makeConstraints {
            $0.leading.equalTo(postImageView.snp.trailing).offset(10.1)
            $0.centerY.equalTo(timeLabel)
            $0.width.height.equalTo(12.8)
        }
        
        frameView.addSubview(placeImageView)
        placeImageView.snp.makeConstraints {
            $0.centerX.equalTo(timeImageView)
            $0.centerY.equalTo(placeLabel)
        }
        
        frameView.addSubview(participantsImageView)
        participantsImageView.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(postImageView.snp.trailing).offset(9.7)
            $0.width.equalTo(131.0)
            $0.height.equalTo(26.0)
        }
        
        frameView.addSubview(disabledView)
        disabledView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        disabledView.addSubview(disabledImageView)
        disabledImageView.snp.makeConstraints {
            $0.edges.equalTo(postImageView).inset(10.0)
        }
    }
}

// MARK: - Bind
extension ProfileHangoutCell {
    func bind(with hangout: Hangout) {
        postImageView.kf.setImage(with: hangout.postImageURL)
        titleLabel.text = hangout.title
        timeLabel.text = hangout.meetTime.toString(dateFormat: "dd. MMM. HH:mm")
        placeLabel.text = hangout.placeName
        
        disabledView.isHidden = (hangout.state == .available)
        if hangout.state != .available {
            disabledImageView.image = UIImage(named: "hangout_\(hangout.state.rawValue)")
        }
    }
}
