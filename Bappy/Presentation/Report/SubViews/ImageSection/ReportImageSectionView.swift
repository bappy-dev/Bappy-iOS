//
//  ReportImageSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "ReportPhotoCell"

final class ReportImageSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: ReportImageSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let photoCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.textColor = .bappyBrown
        label.text = "Photo"
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 12.0
        flowLayout.itemSize = .init(width: 105.0, height: 138.0)
        flowLayout.sectionInset = .init(top: 0, left: 31.0, bottom: 0, right: 26.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ReportPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let numOfImageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 12.0)
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: ReportImageSectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
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

// MARK: - Bind
extension ReportImageSectionView {
    private func bind() {
        collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.selectedImages
            .drive(collectionView.rx.items) { collectionView, item, image in
                let indexPath = IndexPath(item: item, section: 0)
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as! ReportPhotoCell
                
                if item == 0 {
                    cell.isFirstCell = true
                } else {
                    cell.isFirstCell = false
                    cell.image = image
                    cell.delegate = self
                    cell.indexPath = indexPath
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.output.numOfImages
            .compactMap { $0 }
            .drive(numOfImageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - ReportPhotoCellDelegate
extension ReportImageSectionView: ReportPhotoCellDelegate {
    func removePhoto(indexPath: IndexPath) {
        viewModel.input.removePhoto.onNext(indexPath)
    }
}
