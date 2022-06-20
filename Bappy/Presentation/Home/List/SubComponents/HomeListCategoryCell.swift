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
    var category: String = "" {
        didSet {
            categoryLabel.text = category
        }
    }
    
    override var isSelected: Bool {
        didSet {
            categoryLabel.backgroundColor = isSelected ? .bappyYellow : .bappyLightgray
        }
    }
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 18.0)
        label.textAlignment = .center
        label.textColor = .bappyBrown
        label.layer.cornerRadius = 16.0
        label.backgroundColor = .bappyLightgray
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
        contentView.backgroundColor = .white
    }
    
    private func layout() {
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.5)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
