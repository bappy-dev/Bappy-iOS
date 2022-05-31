//
//  SearchPlaceCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit

final class SearchPlaceCell: UITableViewCell {
    
    // MARK: Properties
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "place")
        imageView.contentMode = .center
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Haeundae Beach"
        label.font = .roboto(size: 14.0)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Busan, Haeundae, Jungdong, 1015"
        label.font = .roboto(size: 10.0, family: .Light)
        label.textColor = UIColor(named: "bappy_brown")
        label.lineBreakMode = .byTruncatingTail
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
        contentView.addSubview(placeImageView)
        placeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.8)
            $0.leading.equalToSuperview().inset(3.0)
            $0.width.equalTo(13.0)
            $0.height.equalTo(18.0)
        }
        
        contentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.centerY.equalTo(placeImageView)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(6.0)
        }
        
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(6.0)
            $0.leading.equalTo(placeLabel)
            $0.trailing.equalToSuperview().inset(5.0)
        }
    }
}
