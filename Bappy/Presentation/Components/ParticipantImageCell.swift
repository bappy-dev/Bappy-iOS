//
//  ParticipantImageCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/20.
//

import UIKit
import SnapKit

final class ParticipantImageCell: UICollectionViewCell {
    
    // MARK: Properties
    enum Size: String {
        case medium, small
    }
    
    var size: Size = .small {
        didSet { configure() }
    }
    
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        
////        print("DEBUG: ParticipantCell layoutSubviews..")
//    }

    
    // MARK: Helpers
    private func configure() {
        participantImageView.layer.cornerRadius = size == .small ? 9.0 : 20.5
        participantImageView.image = UIImage(named: "no_profile_\(size.rawValue.first!)")
    }
    
    private func layout() {
        contentView.addSubview(participantImageView)
        participantImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
