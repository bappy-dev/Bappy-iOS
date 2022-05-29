//
//  RegisterPersonalityView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit

final class RegisterPersonalityView: UIView {
    
    // MARK: Properties
    private let personalityQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your personality?"
        label.font = .roboto(size: 16.0)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()
    
    private lazy var spontaneousButton: SelectionButton = {
        let button = SelectionButton(title: "Spontaneous")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var planningButton: SelectionButton = {
        let button = SelectionButton(title: "Planning")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var talkativeButton: SelectionButton = {
        let button = SelectionButton(title: "Talkative")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var shyButton: SelectionButton = {
        let button = SelectionButton(title: "Shy")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var empathaticButton: SelectionButton = {
        let button = SelectionButton(title: "Empathatic")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var calmButton: SelectionButton = {
        let button = SelectionButton(title: "Calm")
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
        button.isButtonSelected = !button.isButtonSelected
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(personalityQuestionLabel)
        personalityQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(personalityQuestionLabel).offset(-3.0)
            $0.leading.equalTo(personalityQuestionLabel.snp.trailing).offset(6.0)
        }
        
        let stackView1 = UIStackView(
            arrangedSubviews: [
                spontaneousButton,
                planningButton,
                talkativeButton])
        
        let stackView2 = UIStackView(
            arrangedSubviews: [
                shyButton,
                empathaticButton,
                calmButton])
        [stackView1, stackView2].forEach { stackView in
            stackView.spacing = 19.0
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
        }
    
        self.addSubview(stackView1)
        stackView1.snp.makeConstraints {
            $0.top.equalTo(personalityQuestionLabel.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        self.addSubview(stackView2)
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(22.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
    }
}

