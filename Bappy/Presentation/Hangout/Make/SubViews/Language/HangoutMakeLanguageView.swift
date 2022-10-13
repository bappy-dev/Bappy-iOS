//
//  HangoutMakeLanguageView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeLanguageView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeLanguageViewModel
    private let disposeBag = DisposeBag()
    
    private let languageCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose\na language"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()

    private let languageTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "make_language"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the language",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 25.0, height: 15.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = .rgb(241, 209, 83, 1)
        return underlinedView
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakeLanguageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(languageCaptionLabel)
        languageCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(languageTextField)
        languageTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(54.0)
        }
        
        self.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.top.equalTo(languageCaptionLabel.snp.bottom).offset(119.0)
            $0.top.equalTo(languageTextField.snp.bottom).offset(7.0)
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(1.0)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension HangoutMakeLanguageView {
    private func bind() {
        languageTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.text
            .compactMap { $0 }
            .emit(to: languageTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.dismissKeyboard
            .emit(to: languageTextField.rx.endEditing)
            .disposed(by: disposeBag)
    }
}
 
