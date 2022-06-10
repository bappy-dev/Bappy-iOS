//
//  HangoutPictureView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

protocol HangoutPictureViewDelegate: AnyObject {
    func addPhoto()
    func removePhoto(indexPath: IndexPath)
}

private let reuseIdentifier = "HangoutPictureCell"
final class HangoutPictureView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutPictureViewDelegate?
    
    var selectedImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
    }
    
    private let pictureCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please add a picture of the place!"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HangoutPictureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        self.backgroundColor = .white
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [asteriskLabel])
        vStackView.alignment = .top
        let hStackView = UIStackView(arrangedSubviews: [pictureCaptionLabel, vStackView])
        hStackView.spacing = 3.0
        hStackView.alignment = .fill
        hStackView.axis = .horizontal
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            let height: CGFloat = (UIScreen.main.bounds.width - 140.0) * 138.0 / 255.0 + 25.0
            $0.top.equalTo(hStackView.snp.bottom).offset(29.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HangoutPictureView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HangoutPictureCell
        if indexPath.item == 0 {
            cell.isFirstCell = true
        } else {
            cell.image = selectedImages[indexPath.item - 1]
            cell.delegate = self
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HangoutPictureView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item == 0 else { return }
        delegate?.addPhoto()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HangoutPictureView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 115.0
        let height: CGFloat = (width - 25.0) / 250.0 * 138.0 + 25.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 70.0, bottom: 0, right: 70.0)
    }
}

// MARK: - ReportPhotoCellDelegate
extension HangoutPictureView: HangoutPictureCellDelegate {
    func removePhoto(indexPath: IndexPath) {
        delegate?.removePhoto(indexPath: indexPath)
    }
}
