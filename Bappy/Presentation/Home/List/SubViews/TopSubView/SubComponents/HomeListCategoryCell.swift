//
//  HomeListCategoryCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

final class HomeListCategoryCell: UICollectionViewCell {
    
    // MARK: Properties
    var isCellSelected: Bool = false {
        didSet {
            contentView.backgroundColor = isCellSelected ? .bappyYellow : .bappyLightgray
        }
    }
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 18.0)
        label.textAlignment = .center
        label.textColor = .bappyBrown
        label.backgroundColor = .clear
        label.clipsToBounds = true
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
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.backgroundColor = .bappyLightgray
        contentView.layer.cornerRadius = 16.0
    }
    
    private func layout() {
        contentView.snp.makeConstraints {
            $0.height.equalTo(32.0)
        }
        
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.height.equalTo(32.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension HomeListCategoryCell {
    func bind(with category: Hangout.Category) {
        categoryLabel.text = category.description
    }
}
