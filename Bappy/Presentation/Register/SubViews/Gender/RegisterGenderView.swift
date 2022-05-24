//
//  RegisterGenderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit

final class RegisterGenderView: UIView {
    
    // MARK: Properties
    private let genderQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Select your gender?"
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
    
    private lazy var maleButton: SelectionButton = {
        let button = SelectionButton(title: "Male")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var femaleButton: SelectionButton = {
        let button = SelectionButton(title: "Female")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var otherButton: SelectionButton = {
        let button = SelectionButton(title: "Other")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
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
    private func selectionButtonHandler(button: SelectionButton) {
        [maleButton, femaleButton, otherButton].forEach {
            $0.isButtonSelected = ($0 == button)
        }
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(genderQuestionLabel)
        genderQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(genderQuestionLabel).offset(-3.0)
            $0.leading.equalTo(genderQuestionLabel.snp.trailing).offset(6.0)
        }
        
        self.addSubview(maleButton)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                maleButton,
                femaleButton,
                otherButton])
        stackView.spacing = 19.0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(genderQuestionLabel.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
    }
}
