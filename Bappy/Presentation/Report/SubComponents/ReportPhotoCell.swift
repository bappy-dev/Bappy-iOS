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
        didSet { setAddPhotoCell() }
    }

    var image: UIImage? {
        didSet {
            removeImageButton.isHidden = false
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.image = self.image
        }
    }

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "bappy_lightgray")
        imageView.layer.cornerRadius = 11.5
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var removeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "remove"), for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveImageButton), for: .touchUpInside)
        return button
    }()

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        removeImageButton.isHidden = true
        photoImageView.image = UIImage(named: "photo")
        photoImageView.contentMode = .center
    }

    private func layout() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(removeImageButton)
        removeImageButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(44.0)
        }
    }
}
