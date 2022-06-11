//
//  HangoutImageCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import Kingfisher

final class HangoutImageCell: UICollectionViewCell {
    
    // MARK: Properties
    private let hangoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
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
        contentView.backgroundColor = .white
        hangoutImageView.kf.setImage(with: URL(string: EXAPMLE_IMAGE3_URL))
    }
    
    private func layout() {
        contentView.addSubview(hangoutImageView)
        hangoutImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
