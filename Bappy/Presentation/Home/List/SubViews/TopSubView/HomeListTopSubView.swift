//
//  HomeListTopSubView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "HomeListCategoryCell"
final class HomeListTopSubView: UIView {
    
    // MARK: Properties
    private let viewModel: HomeListTopSubViewModel
    private let disposeBag = DisposeBag()
    
    private let sortingOrderButton = UIButton()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = 11.0
        flowLayout.sectionInset = .init(top: 0, left: 3.0, bottom: 0, right: 20.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HomeListCategoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let sortingOrderTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 18.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: HomeListTopSubViewModel) {
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
        let hDividingView1 = UIView()
        let hDividingView2 = UIView()
        let vDividingView = UIView()
        hDividingView1.backgroundColor = .black.withAlphaComponent(0.12)
        hDividingView2.backgroundColor = .black.withAlphaComponent(0.12)
        vDividingView.backgroundColor = .black.withAlphaComponent(0.12)
        
        let localeButtonImage = UIImage(systemName: "arrowtriangle.down.fill")
        let localeButtonImageView = UIImageView(image: localeButtonImage)
        localeButtonImageView.tintColor = .bappyYellow
        localeButtonImageView.contentMode = .scaleToFill
        
        self.addSubview(hDividingView1)
        hDividingView1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(14.0)
            $0.height.equalTo(1.0)
        }
        
        self.addSubview(vDividingView)
        vDividingView.snp.makeConstraints {
            $0.top.equalTo(hDividingView1.snp.bottom).offset(4.5)
            $0.trailing.equalToSuperview().inset(119.5)
            $0.width.equalTo(1.0)
            $0.height.equalTo(34.0)
        }
        
        self.addSubview(hDividingView2)
        hDividingView2.snp.makeConstraints {
            $0.top.equalTo(vDividingView.snp.bottom).offset(4.5)
            $0.leading.trailing.equalTo(hDividingView1)
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview().inset(12.5)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(hDividingView1.snp.bottom)
            $0.leading.equalTo(hDividingView1)
            $0.trailing.equalTo(vDividingView.snp.leading)
            $0.bottom.equalTo(hDividingView2.snp.top)
        }
        
        self.addSubview(sortingOrderButton)
        sortingOrderButton.snp.makeConstraints {
            $0.top.equalTo(hDividingView1.snp.bottom)
            $0.bottom.equalTo(hDividingView2.snp.top)
            $0.leading.equalTo(vDividingView.snp.trailing)
            $0.trailing.equalTo(hDividingView1)
        }
        
        sortingOrderButton.addSubview(localeButtonImageView)
        localeButtonImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18.0)
            $0.width.equalTo(12.0)
            $0.height.equalTo(12.0)
            $0.trailing.equalToSuperview().inset(2.0)
        }
        
        sortingOrderButton.addSubview(sortingOrderTitleLabel)
        sortingOrderTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5.0)
            $0.trailing.equalTo(localeButtonImageView.snp.leading).offset(-5.0)
        }
    }
}
// MARK: - Bind
extension HomeListTopSubView {
    private func bind() {
        collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        sortingOrderButton.rx.tap
            .bind(to: viewModel.input.sortingButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.sorting
            .drive(sortingOrderTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.categories
            .drive(collectionView.rx.items) { collectionView, item, element in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: IndexPath(item: item, section: 0)
                ) as! HomeListCategoryCell
                cell.bind(with: element.key)
                cell.isCellSelected = element.value
                return cell
            }
            .disposed(by: disposeBag)
    }
}