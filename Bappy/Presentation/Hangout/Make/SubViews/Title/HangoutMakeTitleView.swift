//
//  HangoutMakeTitleView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeTitleView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeTitleViewModel
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Write the title\nof Hangout"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the hangout title",
            attributes: [.foregroundColor: UIColor.bappyGray])
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = .rgb(241, 209, 83, 1)
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
    init(viewModel: HangoutMakeTitleViewModel) {
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
    private func updateTextFieldPosition(bottomButtonHeight: CGFloat) {
        let labelPosition = scrollView.frame.height - ruleDescriptionLabel.frame.maxY
        let y = (bottomButtonHeight > labelPosition) ? bottomButtonHeight - labelPosition + 5.0 : 0
        let offset = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    private func configure() {
        self.backgroundColor = .white
        ruleDescriptionLabel.text = "Enter 10-20 characters long"
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        self.addSubview(titleCaptionLabel)
        titleCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleCaptionLabel.snp.bottom).offset(5.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1000.0)
        }
        
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
        }
        
        contentView.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(titleTextField.snp.bottom).offset(7.0)
        }
        
        contentView.addSubview(ruleDescriptionLabel)
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(underlinedView.snp.bottom).offset(10.0)
            $0.leading.equalTo(underlinedView).offset(5.0)
        }
    }
}

// MARK: - Bind
extension HangoutMakeTitleView {
    private func bind() {
        titleTextField.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        titleTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.modifiedText
            .emit(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideRule
            .emit(to: ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.keyboardWithButtonHeight
            .emit(onNext: { [weak self] height in
                self?.updateTextFieldPosition(bottomButtonHeight: height)
            })
            .disposed(by: disposeBag)
    }
}
