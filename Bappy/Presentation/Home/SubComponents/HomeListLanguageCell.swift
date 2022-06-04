//
//  HomeListLanguageCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/04.
//

import UIKit
import SnapKit

final class HomeListLanguageCell: UICollectionViewCell {
    
    // MARK: Properties
    var isFirstCell: Bool = false {
        didSet {
            languageImageView.isHidden = !isFirstCell
            languageLabel.isHidden = isFirstCell
        }
    }
    
    var langauge: String = "" {
        didSet {
            languageLabel.text = langauge
        }
    }
    
    override var isSelected: Bool {
        didSet {
            languageLabel.backgroundColor = isSelected ? UIColor(named: "bappy_yellow") : UIColor(named: "bappy_lightgray")
        }
    }
    
    private let languageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_language")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 18.0)
        label.textAlignment = .center
        label.textColor = UIColor(named: "bappy_brown")
        label.layer.cornerRadius = 16.0
        label.backgroundColor = UIColor(named: "bappy_lightgray")
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
        contentView.addSubview(languageImageView)
        languageImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8.5)
            $0.leading.trailing.equalToSuperview().inset(2.0)
        }
        
        contentView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.5)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
