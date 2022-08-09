//
//  SearchPlaceCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchPlaceCell: UITableViewCell {
    
    // MARK: Properties
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .bappyBrown
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 16.0, family: .Medium)
        label.numberOfLines = 0
        label.textColor = .bappyBrown
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Light)
        label.numberOfLines = 0
        label.textColor = .bappyBrown
        label.lineBreakMode = .byWordWrapping
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
            $0.top.equalToSuperview().inset(6.8)
            $0.leading.equalToSuperview().inset(23.0)
            $0.width.equalTo(13.0)
            $0.height.equalTo(18.0)
        }
        
        contentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.8)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(6.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(23.0)
        }
        
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(3.0)
            $0.leading.equalTo(placeLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(23.0)
            $0.bottom.equalToSuperview().inset(10.8)
        }
    }
}

// MARK: - Methods
extension SearchPlaceCell {
    func setupCell(with map: Map) {
        placeLabel.text = map.name
        addressLabel.text = map.address
        
        placeImageView.kf.setImage(
            with: map.iconURL,
            placeholder: UIImage(named: "place"),
            options: nil) { [weak self] result in
                guard case let Result.success(imageResult) = result else { return }
                DispatchQueue.main.async {
                    self?.placeImageView.image = imageResult.image.withRenderingMode(.alwaysTemplate)
                }
            }
    }
}
