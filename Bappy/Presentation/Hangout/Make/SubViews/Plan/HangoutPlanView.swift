//
//  HangoutPlanView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

final class HangoutPlanView: UIView {
    
    // MARK: Properties
    private let planCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please write the Hangout Plan freely!"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()
    
    private let planTextView: UITextView = {
        let textView = UITextView()
//        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .roboto(size: 14.0)
        textView.textColor = UIColor(named: "bappy_brown")
        textView.textAlignment = .left
        return textView
    }()
    
    private let planPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter the contents."
        label.textColor = UIColor(red: 140.0/255.0, green: 136.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        label.font = .roboto(size: 14.0, family: .Light)
        label.numberOfLines = 0
        return label
    }()
    
    private let planBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 12.0
        return backgroundView
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
    
    // MARK: Actions
    @objc
    private func didTextChange() {
        planPlaceholderLabel.isHidden = !planTextView.text.isEmpty
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(didTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [asteriskLabel])
        vStackView.alignment = .top
        let hStackView = UIStackView(arrangedSubviews: [planCaptionLabel, vStackView])
        hStackView.spacing = 3.0
        hStackView.alignment = .fill
        hStackView.axis = .horizontal
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
//        self.addSubview(planBackgroundView)
//        planBackgroundView.snp.makeConstraints {
//            $0.top.equalTo(hStackView.snp.bottom).offset(23.0)
//            $0.leading.trailing.equalToSuperview().inset(43.0)
//        }
      
        self.addSubview(planBackgroundView)
        planBackgroundView.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(43.0)
            $0.height.equalTo(132.0)
//            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        planBackgroundView.addSubview(planTextView)
        planTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.height.equalTo(120.0)
        }

        planTextView.addSubview(planPlaceholderLabel)
        planPlaceholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4.0)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(8.0)
        }
    }
}
