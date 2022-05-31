//
//  HangoutPictureCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

protocol HangoutPictureCellDelegate: AnyObject {
    func removePhoto(indexPath: IndexPath)
}

final class HangoutPictureCell: UICollectionViewCell {
    
    // MARK: Properties
    var indexPath: IndexPath?
    weak var delegate: HangoutPictureCellDelegate?

    var isFirstCell: Bool = false {
        didSet { setAddPhotoCell() }
    }

    var image: UIImage? {
        didSet {
            addPictureImageView.isHidden = true
            removePictureButton.isHidden = false
            pictureImageView.isHidden = false
            pictureImageView.image = self.image
        }
    }

    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "bappy_lightgray")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let addPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "picture_add")
        imageView.contentMode = .center
        return imageView
    }()

    private lazy var removePictureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "picture_remove"), for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveImageButton), for: .touchUpInside)
        return button
    }()
    
    private let containerView = UIView()

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
    @objc private func didTapRemoveImageButton() {
        guard let indexPath = indexPath else { return }
        delegate?.removePhoto(indexPath: indexPath)
    }

    // MARK: Helpers
    private func setAddPhotoCell() {
        addPictureImageView.isHidden = false
        removePictureButton.isHidden = true
        pictureImageView.isHidden = true
    }
    
    private func configure() {
        contentView.backgroundColor = .white
        containerView.backgroundColor = UIColor(named: "bappy_lightgray")
        containerView.layer.cornerRadius = 12.0
        containerView.clipsToBounds = false
    }

    private func layout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12.5)
        }
        
        containerView.addSubview(pictureImageView)
        pictureImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubview(addPictureImageView)
        addPictureImageView.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.top).offset(3.0)
            $0.centerX.equalTo(containerView.snp.trailing)
            $0.width.height.equalTo(23.0)
        }
        
        containerView.addSubview(removePictureButton)
        removePictureButton.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.top).offset(3.0)
            $0.centerX.equalTo(containerView.snp.trailing)
            $0.width.height.equalTo(44.0)
        }
    }
}
