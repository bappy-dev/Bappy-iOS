//
//  ReportPhotoCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit

protocol ReportPhotoCellDelegate: AnyObject {
    func removePhoto(indexPath: IndexPath)
}

final class ReportPhotoCell: UICollectionViewCell {
    
    // MARK: Properties
    var indexPath: IndexPath?
    weak var delegate: ReportPhotoCellDelegate?

    var isFirstCell: Bool = false {
        didSet {
            addImageView.isHidden = !isFirstCell
            removeImageButton.isHidden = isFirstCell
            photoImageView.isHidden = isFirstCell
        }
    }

    var image: UIImage? {
        didSet {
            photoImageView.image = self.image
        }
    }

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 11.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "picture_add")
        return imageView
    }()

    private lazy var removeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "picture_remove"), for: .normal)
        button.addTarget(self, action: #selector(removeIamgeButtonHandler), for: .touchUpInside)
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
    @objc private func removeIamgeButtonHandler() {
        guard let indexPath = indexPath else { return }
        delegate?.removePhoto(indexPath: indexPath)
    }

    // MARK: Helpers
    private func configure() {
        contentView.backgroundColor = .clear
        containerView.backgroundColor = UIColor(named: "bappy_lightgray")
        containerView.layer.cornerRadius = 11.5
    }

    private func layout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(8.0)
            $0.trailing.equalToSuperview().inset(5.0)
        }
        
        containerView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(addImageView)
        addImageView.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.top).offset(5.0)
            $0.centerX.equalTo(containerView.snp.trailing).offset(-5.0)
            $0.width.height.equalTo(23.0)
        }
        
        contentView.addSubview(removeImageButton)
        removeImageButton.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.top).offset(5.0)
            $0.centerX.equalTo(containerView.snp.trailing).offset(-5.0)
            $0.width.height.equalTo(44.0)
        }
    }
}
