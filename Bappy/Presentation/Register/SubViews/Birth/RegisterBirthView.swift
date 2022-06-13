//
//  RegisterBirthView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit

final class RegisterBirthView: UIView {
    
    // MARK: Properties
    private let viewModel: RegisterBirthViewModel
    
    private let birthCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "When\nwere you born"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var birthTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
//        textField.attributedPlaceholder = NSAttributedString(
//            string: "Select your birth date",
//            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        textField.addTarget(self, action: #selector(showBirthPicker), for: .editingDidBegin)
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        underlinedView.addBappyShadow(shadowOffsetHeight: 1.0)
        return underlinedView
    }()
    
    private lazy var birthPickerView: BirthPickerView = {
        let birthPickerView = BirthPickerView()
//        birthPickerView.isHidden = true
        birthPickerView.delegate = self
        return birthPickerView
    }()
    
    // MARK: Lifecycle
    init(viewModel: RegisterBirthViewModel) {
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
    private func showBirthPicker() {
        self.endEditing(false)
        UIView.transition(with: birthPickerView,
                          duration: 0.3,
                          options: .transitionCrossDissolve) {
            self.birthPickerView.isHidden = false
        }
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(birthCaptionLabel)
        birthCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(birthTextField)
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthCaptionLabel.snp.bottom).offset(92.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
        }
        
        self.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(birthTextField.snp.bottom).offset(7.0)
        }
        
        self.addSubview(birthPickerView)
        birthPickerView.snp.makeConstraints {
            $0.top.equalTo(birthCaptionLabel.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(27.0)
            $0.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(308.0)
        }
    }
}

// MARK: - BirthPickerViewDelegate
extension RegisterBirthView: BirthPickerViewDelegate {
    func birthPickerViewDidSelect(birthDate: String) {
        birthTextField.text = birthDate
    }
}
