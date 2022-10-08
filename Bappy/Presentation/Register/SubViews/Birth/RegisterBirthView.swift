//
//  RegisterBirthView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterBirthView: UIView {
    
    // MARK: Properties
    private let viewModel: RegisterBirthViewModel
    private let disposeBag = DisposeBag()
    
    private let birthCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "When\nwere you born"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var birthTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.addTarget(self, action: #selector(showBirthPicker), for: .editingDidBegin)
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        return underlinedView
    }()
    
    private let birthPickerView: BirthPickerView
    
    // MARK: Lifecycle
    init(viewModel: RegisterBirthViewModel) {
        let birthPickerViewModel = viewModel.subViewModels.birthPickerViewModel
        self.viewModel = viewModel
        self.birthPickerView = BirthPickerView(viewModel: birthPickerViewModel)
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
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
        self.addSubviews([birthCaptionLabel, birthTextField, underlinedView, birthPickerView])
        birthCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthCaptionLabel.snp.bottom).offset(92.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
        }
        
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(birthTextField.snp.bottom).offset(7.0)
        }
        
        birthPickerView.snp.makeConstraints {
            $0.top.equalTo(birthCaptionLabel.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(27.0)
            $0.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(308.0)
        }
    }
}

// MARK: - Bind
extension RegisterBirthView {
    func bind() {
        viewModel.output.date
            .emit(to: birthTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
