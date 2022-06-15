//
//  HangoutMakeLimitView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeLimitView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeLimitViewModel
    private let disposeBag = DisposeBag()
    
    private var number: Int = 4
    
    private let limitCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "How\nmany people?"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.font = .roboto(size: 65.0, family: .Bold)
        label.textColor = .bappyBrown
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
        label.font = .roboto(size: 15.0, family: .Regular)
        label.textColor = .black.withAlphaComponent(0.33)
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakeLimitViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
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
        self.addSubview(limitCaptionLabel)
        limitCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(limitCaptionLabel.snp.bottom).offset(88.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(minusButton)
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.centerY.equalTo(numberLabel).offset(4.0)
            $0.centerX.equalToSuperview().offset(-80.0)
        }
        
        self.addSubview(plusButton)
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.centerY.equalTo(minusButton)
            $0.centerX.equalToSuperview().offset(80.0)
        }
        
        self.addSubview(discriptionLabel)
        discriptionLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(15.0)
            $0.centerX.equalToSuperview()
        }
    }
}
