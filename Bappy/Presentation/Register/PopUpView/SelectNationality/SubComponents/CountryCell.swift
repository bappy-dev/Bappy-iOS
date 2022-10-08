//
//  CountryCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/12.
//

import UIKit
import SnapKit

final class CountryCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "CountryCell"
    
    var country: Country? {
        didSet {
            guard let country = country else { return }
            countryLabel.text = country.name
            countryFlagLabel.text = country.flag
        }
    }
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 33.0)
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(countryFlagLabel)
        countryFlagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15.0)
        }
    }
}
