//
//  HangoutCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit
import Kingfisher

protocol HangoutCellDelegate: AnyObject {
    func showDetailView(_ indexPath: IndexPath)
}

final class HangoutCell: UITableViewCell {
    
    // MARK: Properties
    weak var delegate: HangoutCellDelegate?
    var indexPath: IndexPath?
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .bappyLightgray
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 32.0, family: .Bold)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_time")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 17.0, family: .Medium)
        label.textColor = .white
        label.addBappyShadow()
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 17.0, family: .Medium)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.addBappyShadow()
        return label
    }()
    
    private let participantsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_participants")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let likeButton = BappyLikeButton()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cell_more"), for: .normal)
        button.addTarget(self, action: #selector(moreButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let transparentView: UIView = {
        let transparentView = UIView()
        transparentView.backgroundColor = .black.withAlphaComponent(0.5)
        transparentView.layer.cornerRadius = 17.0
        return transparentView
    }()
    
    private let disabledImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        return imageView
    }()
    
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
//    @objc
//    private func toggleLikeButton(_ button: UIButton) {
//        button.isSelected = !button.isSelected
//        let normalImage = button.isSelected ? UIImage(named: "heart_fill") : UIImage(named: "heart")
//        button.setImage(normalImage, for: .normal)
//    }
    
    @objc func moreButtonHandler(_ button: UIButton) {
        guard let indexPath = indexPath else { return }
        delegate?.showDetailView(indexPath)
    }
    
    // MARK: Helpers
    private func configure() {
        contentView.backgroundColor = .white
    }
    
    private func layout() {
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(11.0)
        }
        
        postImageView.addSubview(transparentView)
        transparentView.snp.makeConstraints {
            $0.bottom.equalTo(postImageView).offset(30.0)
            $0.top.equalTo(postImageView.snp.bottom).offset(-153.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        transparentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
        
        transparentView.addSubview(timeImageView)
        timeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56.3)
            $0.leading.equalToSuperview().inset(23.3)
            $0.width.height.equalTo(16.8)
        }
        
        transparentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImageView.snp.trailing).offset(5.0)
            $0.centerY.equalTo(timeImageView)
        }
        
        transparentView.addSubview(placeImageView)
        placeImageView.snp.makeConstraints {
            $0.top.equalTo(timeImageView.snp.bottom).offset(7.4)
            $0.centerX.equalTo(timeImageView)
            $0.width.equalTo(15.0)
            $0.height.equalTo(18.0)
        }
        
        transparentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel)
            $0.centerY.equalTo(placeImageView)
        }
        
        transparentView.addSubview(participantsImageView)
        participantsImageView.snp.makeConstraints {
            $0.bottom.equalTo(postImageView).offset(-13.8)
            $0.leading.equalTo(titleLabel).offset(6.0)
            $0.width.equalTo(163.0)
            $0.height.equalTo(32.0)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.bottom.equalTo(postImageView).offset(-15.0)
            $0.trailing.equalToSuperview().inset(14.0)
            $0.width.equalTo(140.0)
            $0.height.equalTo(57.0)
        }
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.0)
            $0.trailing.equalToSuperview().inset(4.0)
            $0.width.height.equalTo(44.0)
        }
        
        contentView.addSubview(disabledImageView)
        disabledImageView.snp.makeConstraints {
            $0.edges.equalTo(postImageView)
        }
    }
}

// MARK: - Methods
extension HangoutCell {
    func bind(with hangout: Hangout) {
        titleLabel.text = hangout.title
        timeLabel.text = hangout.meetTime
        placeLabel.text = hangout.placeName
        postImageView.kf.setImage(with: hangout.postImageURL)
        likeButton.isSelected = hangout.userHasLiked
        
        disabledImageView.isHidden = hangout.state == .available
        if hangout.state != .available {
            disabledImageView.image = UIImage(named: "hangout_\(hangout.state.rawValue)")
        }
    }
}
