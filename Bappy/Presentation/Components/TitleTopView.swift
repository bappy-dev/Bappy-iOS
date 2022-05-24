//
//  TitleTopView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class TitleTopView: UIView {
    
    // MARK: Properties
    private let title: String
    private let subTitle: String
    
    private let titleView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    // MARK: Lifecycle
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = UIColor(named: "bappy_yellow")
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 1.0
        
        titleView.backgroundColor = .white
        titleView.layer.cornerRadius = 15.0

        titleLabel.text = self.title
        subTitleLabel.text = self.subTitle
    }
    
    private func layout() {
        self.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(-26.0)
            $0.leading.trailing.equalToSuperview().inset(67.0)
            $0.height.equalTo(75.0)
        }
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.centerX.equalToSuperview()
        }
        
        titleView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(17.0)
            $0.centerX.equalToSuperview()
        }
    }
}
