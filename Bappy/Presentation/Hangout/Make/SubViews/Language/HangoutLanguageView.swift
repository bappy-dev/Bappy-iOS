//
//  HangoutLanguageView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

protocol HangoutLanguageViewDelegate: AnyObject {
    func showSelectLanguageView()
}

final class HangoutLanguageView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutLanguageViewDelegate?
    
    private let languageCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please choose a language for Hangout"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()
    
    private lazy var languageTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "make_language"))
        let containerView = UIView()
        textField.font = .roboto(size: 14.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your language",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 15.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(languageTextFieldHandler), for: .editingDidBegin)
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        underlinedView.addBappyShadow(shadowOffsetHeight: 1.0)
        return underlinedView
    }()
    
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
    private func languageTextFieldHandler(_ textField: UITextField) {
        delegate?.showSelectLanguageView()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [asteriskLabel])
        vStackView.alignment = .top
        let hStackView = UIStackView(arrangedSubviews: [languageCaptionLabel, vStackView])
        hStackView.spacing = 3.0
        hStackView.alignment = .fill
        hStackView.axis = .horizontal
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
        self.addSubview(languageTextField)
        languageTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(62.0)
            $0.top.equalTo(languageTextField.snp.bottom).offset(7.0)
            $0.width.equalTo(180.0)
            $0.height.equalTo(1.0)
            $0.centerX.equalToSuperview()
        }
    }
}
