//
//  ReportImageSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit

private let reuseIdentifier = "ReportPhotoCell"

protocol ReportImageSectionViewDelegate: AnyObject {
    func addPhoto()
    func removePhoto(indexPath: IndexPath)
}

final class ReportImageSectionView: UIView {
    
    // MARK: Properties
    weak var delegate: ReportImageSectionViewDelegate?
    
    var selectedImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.numOfImageLabel.text = "\(self.selectedImages.count)/5"
            }
        }
    }
    
    private let photoCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Photo"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ReportPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let numOfImageLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.textColor = UIColor(named: "bappy_brown")
        label.font = .roboto(size: 12.0)
        return label
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
        self.addSubview(photoCaptionLabel)
        photoCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19.0)
            $0.leading.equalToSuperview().inset(33.0)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(photoCaptionLabel.snp.bottom).offset(13.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(138.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        self.addSubview(numOfImageLabel)
        numOfImageLabel.snp.makeConstraints {
            $0.centerY.equalTo(photoCaptionLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(43.0)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ReportImageSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReportPhotoCell
        if indexPath.item == 0 {
            cell.isFirstCell = true
        } else {
            cell.isFirstCell = false
            cell.image = selectedImages[indexPath.item - 1]
            cell.delegate = self
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ReportImageSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item == 0 else { return }
        delegate?.addPhoto()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReportImageSectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105.0, height: 138.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 31.0, bottom: 0, right: 26.0)
    }
}

// MARK: - ReportPhotoCellDelegate
extension ReportImageSectionView: ReportPhotoCellDelegate {
    func removePhoto(indexPath: IndexPath) {
        delegate?.removePhoto(indexPath: indexPath)
    }
}
