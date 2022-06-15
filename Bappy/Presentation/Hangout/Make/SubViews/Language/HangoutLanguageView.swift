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
    var language: String? {
        didSet {
            guard let language = language else { return }
            languageTextField.text = language
        }
    }
    
    private let languageCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose\na language"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()

    private lazy var languageTextField: UITextField = {
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
        textField.addTarget(self, action: #selector(languageTextFieldHandler), for: .editingDidBegin)
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
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
