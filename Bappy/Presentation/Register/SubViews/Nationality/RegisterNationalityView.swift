//
//  RegisterNationalityView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RegisterNationalityView: UIView {
    
    // MARK: Properties
    private let viewModel: RegisterNationalityViewModel
    private let disposeBag = DisposeBag()
    
    private let nationalityCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Where\nare you from"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let nationalityTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "make_language"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Select your nationality",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 25.0, height: 15.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        return underlinedView
    }()
    
    // MARK: Lifecycle
    init(viewModel: RegisterNationalityViewModel) {
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
        self.addSubviews([nationalityCaptionLabel, nationalityTextField, underlinedView])
        nationalityCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        nationalityTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(54.0)
        }
        
        underlinedView.snp.makeConstraints {
            $0.top.equalTo(nationalityCaptionLabel.snp.bottom).offset(119.0)
            $0.top.equalTo(nationalityTextField.snp.bottom).offset(7.0)
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(1.0)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension RegisterNationalityView {
    private func bind() {
        nationalityTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.textFieldTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.country
            .emit(to: nationalityTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
