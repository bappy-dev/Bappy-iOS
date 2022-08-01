//
//  CustomerServiceButton.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit

final class CustomerServiceButton: UIButton {
    
    // MARK: Properties
    let title: String
    
    private let mailImageView = UIImageView()
    private let accessoryImageView = UIImageView()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 20.0, family: .Medium)
        return label
    }()

    // MARK: Lifecycle
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        mailImageView.image = UIImage(named: "service_mail")
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let accessoryImage = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        accessoryImageView.image = accessoryImage
        accessoryImageView.tintColor = .bappyBrown
        captionLabel.text = title
    }
    
    private func layout() {
        self.addSubview(mailImageView)
        mailImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.equalTo(20.0)
            $0.height.equalTo(16.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(mailImageView.snp.trailing).offset(12.0)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(accessoryImageView)
        accessoryImageView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
}
