//
//  DeleteAccountFirstPageView.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import SnapKit

final class DeleteAccountFirstPageView: UIView {
    
    // MARK: Properties
    private let viewModel: DeleteAccountFirstPageViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 24.0, family: .Medium)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let reconfirmLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 26.0, family: .Bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: DeleteAccountFirstPageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        titleLabel.text = "Are we really saying goodbye?"
        subtitleLabel.text = "If you delete your account now, all of your data will be deleted, too. The data include, your hangout posts, planned hangouts, pictures, profile information and likes, etc."
        let stringList = [
            "You cannot make another account for a week.",
            "If there is any hangout you made or planned to join, your profile will not be visible."
        ]
        descriptionLabel.attributedText = NSAttributedString(
            stringList: stringList,
            bullet: "\u{2022}",
            font: .roboto(size: 16.0),
            textColor: .bappyBrown,
            indentation: 15.0,
            lineSpacing: .zero,
            paragraphSpacing: 20.0)
        reconfirmLabel.text = "Do you really want to\nleave BAPPY?"
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36.0)
            $0.leading.equalToSuperview().inset(32.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(34.9)
        }
        
        self.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34.0)
            $0.leading.equalToSuperview().inset(40.0)
            $0.trailing.equalToSuperview().inset(39.0)
        }
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(35.0)
            $0.leading.trailing.equalToSuperview().inset(45.0)
        }
        
        self.addSubview(reconfirmLabel)
        reconfirmLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(73.0)
            $0.bottom.equalToSuperview().inset(30.0)
        }
    }
}
