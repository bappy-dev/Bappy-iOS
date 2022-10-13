//
//  ParticipantImageCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/20.
//

import UIKit
import SnapKit
import Kingfisher

final class ParticipantImageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "ParticipantImageCell"
    
    private let participantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        participantImageView.layer.cornerRadius = 24.0
    }
    
    private func layout() {
        contentView.addSubview(participantImageView)
        participantImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ParticipantImageCell {
    func bind(with profileImageURL: URL?) {
        participantImageView.kf.setImage(with: profileImageURL, placeholder: UIImage(named: "hangout_no_profile"))
    }
}
