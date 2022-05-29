//
//  RegisterBirthView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit

final class RegisterBirthView: UIView {
    
    // MARK: Properties
    private let birthQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Birth date?"
        label.font = .roboto(size: 16.0)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()
    
    private let answerBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 19.5
        return backgroundView
    }()
    
    private lazy var birthTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 14.0)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Select your birth date",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        textField.addTarget(self, action: #selector(showBirthPicker), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var birthPickerView: BirthPickerView = {
        let birthPickerView = BirthPickerView()
        birthPickerView.isHidden = true
        birthPickerView.delegate = self
        return birthPickerView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func showBirthPicker() {
        self.endEditing(false)
        UIView.transition(with: birthPickerView,
                          duration: 0.3,
                          options: .transitionCrossDissolve) {
            self.birthPickerView.isHidden = false
        }
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(birthQuestionLabel)
        birthQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(birthQuestionLabel).offset(-3.0)
            $0.leading.equalTo(birthQuestionLabel.snp.trailing).offset(6.0)
        }
        
        self.addSubview(answerBackgroundView)
        answerBackgroundView.snp.makeConstraints {
            $0.top.equalTo(birthQuestionLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        answerBackgroundView.addSubview(birthTextField)
        birthTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(birthPickerView)
        birthPickerView.snp.makeConstraints {
            $0.top.equalTo(birthQuestionLabel.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(27.0)
            $0.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(308.0)
        }
    }
}

// BirthPickerViewDelegate
extension RegisterBirthView: BirthPickerViewDelegate {
    func birthPickerViewDidSelect(birthDate: String) {
        birthTextField.text = birthDate
    }
}
