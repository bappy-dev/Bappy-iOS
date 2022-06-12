//
//  RegisterNationalityView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit

protocol RegisterNationalityViewDelegate: AnyObject {
    func showSelectNationalityView()
}

final class RegisterNationalityView: UIView {
    
    // MARK: Properties
    weak var delegate: RegisterNationalityViewDelegate?
    var country: Country? {
        didSet {
            guard let country = country else { return }
            nationalityTextField.text = country.name
        }
    }
    
    private let nationalityCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Where\nare you from"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var nationalityTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "make_language"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Select your nationality",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        containerView.frame = CGRect(x: 0, y: 0, width: 25.0, height: 15.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(nationalityTextFieldHandler), for: .editingDidBegin)
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
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func nationalityTextFieldHandler(_ textField: UITextField) {
        delegate?.showSelectNationalityView()
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(nationalityCaptionLabel)
        nationalityCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(nationalityTextField)
        nationalityTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(54.0)
        }
        
        self.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.top.equalTo(nationalityCaptionLabel.snp.bottom).offset(119.0)
            $0.top.equalTo(nationalityTextField.snp.bottom).offset(7.0)
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(1.0)
            $0.centerX.equalToSuperview()
        }
    }
}
