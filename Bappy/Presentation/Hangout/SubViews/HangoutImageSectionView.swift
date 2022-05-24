//
//  HangoutImageSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit

private let reuseIdentifier = "HangoutImageCell"
final class HangoutImageSectionView: UIView {
    
    // MARK: Properties
    private let localeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locale")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let localeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 11.0)
        label.text = "Busan South Korea"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HangoutImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = UIColor(named: "bappy_yellow")
        pageControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return pageControl
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
        let stackView = UIStackView(arrangedSubviews: [
            localeImageView, localeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.contentMode = .center
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(10.0)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(7.0)
//            $0.leading.equalToSuperview().inset(85.0)
//            $0.trailing.equalToSuperview().inset(84.0)
            $0.leading.equalToSuperview().inset(80.0)
            $0.trailing.equalToSuperview().inset(79.0)
            $0.height.equalTo(collectionView.snp.width).multipliedBy(117.0/221.0)
        }
        
        self.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(-6.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: UICollectionViewDataSource
extension HangoutImageSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HangoutImageCell
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HangoutImageSectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 169.0
        let height: CGFloat = width / 221.0 * 117.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5.0)
    }
}
