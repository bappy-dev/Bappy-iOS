//
//  HangoutParticipantsSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "ParticipantImageCell"
final class HangoutParticipantsSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutParticipantsSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let joinCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.text = "Who Join?"
        label.textColor = .bappyBrown
        return label
    }()
    
    private let numOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 16.0)
        label.textColor = .bappyBrown
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 22.0
        flowLayout.itemSize = .init(width: 48.0, height: 48.0)
        flowLayout.sectionInset = .init(top: 0, left: 33.0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ParticipantImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutParticipantsSectionViewModel) {
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
        self.addSubview(joinCaptionLabel)
        joinCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(27.0)
        }
        
        self.addSubview(numOfParticipantsLabel)
        numOfParticipantsLabel.snp.makeConstraints {
            $0.bottom.equalTo(joinCaptionLabel)
            $0.trailing.equalToSuperview().inset(23.0)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(joinCaptionLabel.snp.bottom).offset(15.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
}

// MARK: - Bind
extension HangoutParticipantsSectionView {
    private func bind() {
        viewModel.output.limitNumberText
            .emit(to: numOfParticipantsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.participantIDs
            .drive(collectionView.rx.items) { collectionView, item, element in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: IndexPath(item: item, section: 0))
                as! ParticipantImageCell
                cell.bind(with: element.imageURL)
                return cell
            }
            .disposed(by: disposeBag)
    }
}
