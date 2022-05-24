//
//  HangoutPlanSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit

final class HangoutPlanSectionView: UIView {
    
    // MARK: Properties
    private let planCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.text = "Hangout Plan"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let planTextView: UITextView = {
        let textView = UITextView()
        textView.font = .roboto(size: 12.0, family: .Light)
        textView.textColor = UIColor(named: "bappy_brown")
        textView.textAlignment = .justified
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let backgroundView = UIView()
    
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
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 11.0
        
        planTextView.text = "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Any one wanna join?"
    }
    
    private func layout() {
        self.addSubview(planCaptionLabel)
        planCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(27.0)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(planCaptionLabel.snp.bottom).offset(8.0)
            $0.leading.equalToSuperview().inset(26.0)
            $0.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalToSuperview().inset(16.0)
//            $0.height.equalTo(100.0)
        }
        
        backgroundView.addSubview(planTextView)
        planTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(19.0)
            $0.trailing.equalToSuperview().inset(21.0)
        }
    }
}
