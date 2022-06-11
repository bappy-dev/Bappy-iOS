//
//  HangoutImageSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import Kingfisher

private let reuseIdentifier = "HangoutImageCell"
final class HangoutImageSectionView: UIView {
    
    // MARK: Properties
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setImage(UIImage(named: "heart_fill"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 8.5, left: 6.2, bottom: 8.5, right: 6.2)
        button.addTarget(self, action: #selector(toggleLikeButton), for: .touchUpInside)
        return button
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
    
    // MARK: Actions
    @objc
    private func toggleLikeButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        let normalImage = button.isSelected ? UIImage(named: "heart_fill") : UIImage(named: "heart")
        button.setImage(normalImage, for: .normal)
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        postImageView.kf.setImage(with: URL(string: EXAMPLE_IMAGE2_URL))
    }
    
    private func layout() {
        self.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width).multipliedBy(239.0/390.0)
        }
        
        self.addSubview(likeButton)
        likeButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(5.8)
            $0.trailing.equalToSuperview().inset(9.8)
        }
    }
}

extension HangoutImageSectionView {
    func updateImageHeight(_ hegiht: CGFloat) {
        postImageView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(hegiht)
        }
    }
}
