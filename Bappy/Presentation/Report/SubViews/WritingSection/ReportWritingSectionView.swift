//
//  ReportWritingSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReportWritingSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: ReportWritingSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let reportingTypeCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.textColor = .bappyBrown
        label.text = "I am reporting because..."
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = .bappyYellow
        return label
    }()
    
    private let reportingTypeBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .bappyLightgray
        backgroundView.layer.cornerRadius = 11.5
        return backgroundView
    }()
    
    private let reportingTypeTextField: UITextField = {
        let textField = UITextField()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .rgb(177, 172, 154, 1)
        textField.font = .roboto(size: 12.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Select the reason for reporting.",
            attributes: [.foregroundColor: UIColor.rgb(169, 162, 139, 1)])
        textField.rightView = imageView
        textField.rightViewMode = .always
        return textField
    }()
    
    private let reportingDetailCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.textColor = .bappyBrown
        label.text = "Write More"
        return label
    }()
    
    private let asterisk2Label: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = .bappyYellow
        return label
    }()
    
    private let reportingDetailBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .bappyLightgray
        backgroundView.layer.cornerRadius = 11.5
        return backgroundView
    }()
    
    private let reportingDetailTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .roboto(size: 12.0)
        textView.textColor = .bappyBrown
        textView.textAlignment = .left
        return textView
    }()
    
    private let reportingDetailPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Write if you want to let us know something more."
        label.textColor = .rgb(169, 162, 139, 1)
        label.font = .roboto(size: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: ReportWritingSectionViewModel) {
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
        self.addSubview(reportingTypeCaptionLabel)
        reportingTypeCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(106.0)
            $0.leading.equalToSuperview().inset(31.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(reportingTypeCaptionLabel).offset(-3.0)
            $0.leading.equalTo(reportingTypeCaptionLabel.snp.trailing).offset(2.0)
        }
        
        self.addSubview(reportingTypeBackgroundView)
        reportingTypeBackgroundView.snp.makeConstraints {
            $0.top.equalTo(reportingTypeCaptionLabel.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(29.0)
            $0.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(32.0)
        }
        
        reportingTypeBackgroundView.addSubview(reportingTypeTextField)
        reportingTypeTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.top.bottom.equalToSuperview()
        }
        
        self.addSubview(reportingDetailCaptionLabel)
        reportingDetailCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(reportingTypeBackgroundView.snp.bottom).offset(48.0)
            $0.leading.equalToSuperview().inset(33.0)
        }
        
        self.addSubview(asterisk2Label)
        asterisk2Label.snp.makeConstraints {
            $0.top.equalTo(reportingDetailCaptionLabel).offset(-3.0)
            $0.leading.equalTo(reportingDetailCaptionLabel.snp.trailing).offset(2.0)
        }
        
        self.addSubview(reportingDetailBackgroundView)
        reportingDetailBackgroundView.snp.makeConstraints {
            $0.top.equalTo(reportingDetailCaptionLabel.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(31.0)
            $0.trailing.equalToSuperview().inset(42.0)
            $0.height.equalTo(95.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        reportingDetailBackgroundView.addSubview(reportingDetailTextView)
        reportingDetailTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6.0)
            $0.leading.trailing.equalToSuperview().inset(6.0)
            $0.height.equalTo(83.0)
        }
        
        reportingDetailTextView.addSubview(reportingDetailPlaceholderLabel)
        reportingDetailPlaceholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4.0)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(8.0)
        }
    }
}

// MARK: - Bind
extension ReportWritingSectionView {
    private func bind() {
        reportingTypeTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: reportingTypeTextField.rx.endEditing)
            .disposed(by: disposeBag)
        
        reportingTypeTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        reportingDetailTextView.rx.text.orEmpty
            .bind(to: viewModel.input.detailText)
            .disposed(by: disposeBag)
        
        
        viewModel.output.reportingType
            .emit(to: reportingTypeTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHidePlaceholder
            .drive(reportingDetailPlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
