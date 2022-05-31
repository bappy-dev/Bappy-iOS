//
//  HangoutOpenchatView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

final class HangoutOpenchatView: UIView {
    
    // MARK: Properties
    private let openchatFirstCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please make Kakao Openchat and"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
        return label
    }()
    
    private let openchatSecondCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "write the URL of Openchat!"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0)
        label.textColor = UIColor(named: "bappy_yellow")
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
        self.backgroundColor = .white
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [asteriskLabel])
        vStackView.alignment = .top
        let hStackView = UIStackView(arrangedSubviews: [openchatSecondCaptionLabel, vStackView])
        hStackView.spacing = 3.0
        hStackView.alignment = .fill
        hStackView.axis = .horizontal
        
        self.addSubview(openchatFirstCaptionLabel)
        openchatFirstCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(openchatFirstCaptionLabel.snp.bottom).offset(2.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30.0)
        }
    }
}
