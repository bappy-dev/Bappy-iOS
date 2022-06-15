//
//  RegisterNameView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RegisterNameView: UIView {
    
    // MARK: Properties
    private let viewModel: RegisterNameViewModel
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "What's\nyour name"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your name",
            attributes: [.foregroundColor: UIColor.bappyGray])
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        underlinedView.addBappyShadow(shadowOffsetHeight: 1.0)
        return underlinedView
    }()
    
    private let ruleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0)
        label.textColor = .bappyCoral
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: RegisterNameViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func updateTextFieldPosition(bottomButtonHeight: CGFloat) {
        guard nameTextField.isFirstResponder else { return }
        let labelPosition = scrollView.frame.height - ruleDescriptionLabel.frame.maxY
        let y = (bottomButtonHeight > labelPosition) ? bottomButtonHeight - labelPosition + 5.0 : 0
        let offset = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        ruleDescriptionLabel.text = "Enter at least 3 characters"
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        self.addSubview(nameCaptionLabel)
        nameCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(nameCaptionLabel.snp.bottom).offset(5.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1000.0)
        }
        
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
        }
        
        contentView.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(nameTextField.snp.bottom).offset(7.0)
        }
        
        contentView.addSubview(ruleDescriptionLabel)
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(underlinedView.snp.bottom).offset(10.0)
            $0.leading.equalTo(underlinedView).offset(5.0)
        }
    }
}

// MARK: - Bind
extension RegisterNameView {
    private func bind() {
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.name)
            .disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent(.editingDidBegin)
            .map { _ in }
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.modifiedName
            .emit(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideRule
            .emit(to: ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.keyboardWithButtonHeight
            .emit(onNext: { [weak self] height in
                guard let self = self else { return }
                let labelPosition = self.scrollView.frame.height - self.ruleDescriptionLabel.frame.maxY
                let y = (height > labelPosition) ? height - labelPosition + 5.0 : 0
                let offset = CGPoint(x: 0, y: y)
                self.scrollView.setContentOffset(offset, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
