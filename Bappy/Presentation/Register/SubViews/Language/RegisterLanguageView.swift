//
//  RegisterLanguageView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit

final class RegisterLanguageView: UIView {
    
    // MARK: Properties
    private let languageQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your native language?"
        label.font = .roboto(size: 16.0)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0, alpha: 1.0)
        return label
    }()
    
    private let answerBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 19.5
        return backgroundView
    }()
    
    private let languageTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 14.0)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your language",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        return textField
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(languageQuestionLabel)
        languageQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(languageQuestionLabel).offset(-3.0)
            $0.leading.equalTo(languageQuestionLabel.snp.trailing).offset(6.0)
        }
        
        self.addSubview(answerBackgroundView)
        answerBackgroundView.snp.makeConstraints {
            $0.top.equalTo(languageQuestionLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        answerBackgroundView.addSubview(languageTextField)
        languageTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
    }
}
