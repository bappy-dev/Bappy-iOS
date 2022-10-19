//
//  ProfileReferenceCell.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/19.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileReferenceCell: UITableViewCell {
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = .bappyBrown
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let frameView = UIView()
    
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
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        frameView.backgroundColor = .white
        frameView.layer.cornerRadius = 9.0
        frameView.clipsToBounds = true
    }
    
    private func layout() {
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.trailing.equalToSuperview().inset(13.0)
        }
        
        frameView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.leading.equalToSuperview().inset(6.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(9.0)
        }
        
    }
}

// MARK: - Bind
extension ProfileReferenceCell {
    func bind(with reference: Reference) {
        titleLabel.text = reference.contents
    }
}
