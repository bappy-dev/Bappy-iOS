//
//  ReportWritingSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit

final class ReportWritingSectionView: UIView {
    
    // MARK: Properties
    private let reportingTypeCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "I am reporting because..."
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()
    
    private let reportingTypeBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 11.5
        return backgroundView
    }()
    
    private lazy var reportingTypeTextField: UITextField = {
        let textField = UITextField()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(red: 177.0/255.0, green: 172.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        textField.font = .roboto(size: 12.0)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Select the reason for reporting.",
            attributes: [.foregroundColor: UIColor(red: 169.0/255.0, green: 162.0/255.0, blue: 139.0/255.0, alpha: 1.0)])
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.addTarget(self, action: #selector(didTapReportingType), for: .editingDidBegin)
        return textField
    }()
    
    private let reportingDetailCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        label.text = "Write More"
        return label
    }()

    
    private let reportingDetailBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 11.5
        return backgroundView
    }()
    
    private let reportingDetailTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .roboto(size: 12.0)
        textView.textColor = .black
        textView.textAlignment = .left
        return textView
    }()
    
    private let reportingDetailPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Write if you want to let us know something more."
        label.textColor = UIColor(red: 169.0/255.0, green: 162.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        label.font = .roboto(size: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let dropdownView = ReportTypeDropdownView()
    
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
    private func didTapReportingType(_ textField: UITextField) {
        textField.endEditing(true)
        openDropdown()
    }
    
    @objc
    private func didTextChange() {
        reportingDetailPlaceholderLabel.isHidden = !reportingDetailTextView.text.isEmpty
    }
    
    private func openDropdown() {
        UIView.animate(withDuration: 0.3) {
            self.dropdownView.isHidden = false
            self.dropdownView.snp.updateConstraints {
                $0.height.equalTo(175.0)
            }
            self.layoutIfNeeded()
        }
    }
    
    func closeDropdown() {
        UIView.animate(withDuration: 0.3) {
            self.dropdownView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.layoutIfNeeded()
        } completion: { _ in
//            self.dropdownView.isHidden = true
        }
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(didTextChange), name: UITextView.textDidChangeNotification, object: nil)
        dropdownView.delegate = self
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
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(reportingDetailCaptionLabel)
        reportingDetailCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(reportingTypeBackgroundView.snp.bottom).offset(48.0)
            $0.leading.equalToSuperview().inset(33.0)
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
        
        self.addSubview(dropdownView)
        dropdownView.snp.makeConstraints {
            $0.top.equalTo(reportingTypeBackgroundView.snp.bottom).offset(5.0)
            $0.leading.equalToSuperview().inset(26.0)
            $0.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(0)
        }
    }
}

// MARK: ReportTypeDropdownViewDelegate
extension ReportWritingSectionView: ReportTypeDropdownViewDelegate {
    func didSelectText(_ text: String) {
        reportingTypeTextField.text = text
        closeDropdown()
    }
}
