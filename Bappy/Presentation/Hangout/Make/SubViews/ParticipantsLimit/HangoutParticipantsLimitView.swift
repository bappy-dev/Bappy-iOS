//
//  HangoutParticipantsLimitView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

final class HangoutParticipantsLimitView: UIView {
    
    // MARK: Properties
    private var number: Int = 4
    
    private let limitCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "How many people do you want to meet?"
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
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.font = .roboto(size: 38.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(minusButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(plusButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let discriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Participants Limit  4 ~ 10"
        label.font = .roboto(size: 10.0, family: .Light)
        label.textColor = .black.withAlphaComponent(0.33)
        return label
    }()
    
    private let discriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "make_participants")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    private func minusButtonHandler() {
        number -= 1
        numberLabel.text = "\(number)"
        updateButtonState()
    }
    
    @objc
    private func plusButtonHandler() {
        number += 1
        numberLabel.text = "\(number)"
        updateButtonState()
    }
    
    // MARK: Helpers
    private func updateButtonState() {
        let minusButtonImage = (number == 4) ? UIImage(named: "make_minus_off") : UIImage(named: "make_minus_on")
        minusButton.setImage(minusButtonImage, for: .normal)
        minusButton.isEnabled = !(number == 4)
        
        let plusButtonImage = (number == 10) ? UIImage(named: "make_plus_off") : UIImage(named: "make_plus_on")
        plusButton.setImage(plusButtonImage, for: .normal)
        plusButton.isEnabled = !(number == 10)
        
    }
    
    private func configure() {
        self.backgroundColor = .white
        updateButtonState()
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [asteriskLabel])
        vStackView.alignment = .top
        let hStackView = UIStackView(arrangedSubviews: [limitCaptionLabel, vStackView])
        hStackView.spacing = 3.0
        hStackView.alignment = .fill
        hStackView.axis = .horizontal
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
        self.addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(36.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(minusButton)
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.centerY.equalTo(numberLabel)
            $0.centerX.equalToSuperview().offset(-70.0)
        }
        
        self.addSubview(plusButton)
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.centerY.equalTo(numberLabel)
            $0.centerX.equalToSuperview().offset(70.0)
        }
        
        self.addSubview(discriptionLabel)
        discriptionLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(35.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(discriptionImageView)
        discriptionImageView.snp.makeConstraints {
            $0.centerY.equalTo(discriptionLabel)
            $0.trailing.equalTo(discriptionLabel.snp.leading).offset(-5.0)
            $0.width.equalTo(10.0)
            $0.height.equalTo(8.5)
        }
    }
}
