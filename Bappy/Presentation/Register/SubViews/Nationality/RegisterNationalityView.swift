//
//  RegisterNationalityView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit

final class RegisterNationalityView: UIView {
    
    // MARK: Properties
    private let nationalityQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Where are you from?"
        label.font = .roboto(size: 16.0)
        label.textColor = UIColor(red: 86.0/255.0, green: 69.0/255.0, blue: 8.0/255.0, alpha: 1.0)
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
        backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        backgroundView.layer.cornerRadius = 19.5
        return backgroundView
    }()
    
    private let nationalityTextField: UITextField = {
        let textField = UITextField()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)
        textField.font = .roboto(size: 14.0)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Choose your nationality",
            attributes: [.foregroundColor: UIColor(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)])
        textField.rightView = imageView
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var countryListView = CountryListView()
    
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
        self.addSubview(nationalityQuestionLabel)
        nationalityQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(nationalityQuestionLabel).offset(-3.0)
            $0.leading.equalTo(nationalityQuestionLabel.snp.trailing).offset(6.0)
        }
        
        self.addSubview(answerBackgroundView)
        answerBackgroundView.snp.makeConstraints {
            $0.top.equalTo(nationalityQuestionLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        answerBackgroundView.addSubview(nationalityTextField)
        nationalityTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(countryListView)
        countryListView.snp.makeConstraints {
            $0.top.equalTo(answerBackgroundView.snp.bottom).offset(8.0)
            $0.leading.trailing.equalTo(answerBackgroundView)
        }
    }
}
