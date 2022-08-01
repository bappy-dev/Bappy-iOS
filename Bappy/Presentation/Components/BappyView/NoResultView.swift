//
//  NoResultView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/10.
//

import UIKit
import SnapKit

final class NoResultView: UIView {
    
    // MARK: Properties
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_sulky")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 204.0, height: 254.0)
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops, there is no results\nfor your searching. Try again!\n\n"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 20.0, family: .Medium)
        label.numberOfLines = 4
        label.textAlignment = .center
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
        self.backgroundColor = .clear
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [
            bappyImageView, captionLabel
        ])
        
        vStackView.axis = .vertical
        vStackView.spacing = 48.0
        vStackView.distribution = .fillProportionally
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
