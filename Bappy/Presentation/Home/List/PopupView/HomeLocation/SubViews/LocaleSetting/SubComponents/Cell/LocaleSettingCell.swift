//
//  LocaleSettingCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/23.
//

import UIKit
import SnapKit

final class LocaleSettingCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "LocaleSettingCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Medium)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 14.0, family: .Light)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locale_selected")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26.5)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(15.0)
            $0.height.equalTo(21.0)
        }
        
        contentView.addSubview(placeNameLabel)
        placeNameLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(18.5)
            $0.bottom.equalTo(contentView.snp.centerY).offset(-3.0)
        }
        
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.centerY).offset(3.0)
            $0.leading.equalTo(placeNameLabel)
        }
        
        contentView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(placeNameLabel.snp.trailing).offset(15.0)
            $0.leading.greaterThanOrEqualTo(addressLabel.snp.trailing).offset(15.0)
            $0.trailing.equalToSuperview().inset(25.0)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(18.0)
            $0.height.equalTo(14.0)
        }
    }
}

// MARK: Bind
extension LocaleSettingCell {
    func bind(with location: Location) {
        placeNameLabel.text = location.name
        addressLabel.text = location.address
        selectedImageView.isHidden = !location.isSelected
    }
}
