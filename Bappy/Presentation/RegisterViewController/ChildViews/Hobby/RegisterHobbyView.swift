//
//  RegisterHobbyView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit

final class RegisterHobbyView: UIView {
    
    // MARK: Properties
    private let hobbyQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your hobby?"
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
    
    private lazy var moviesButton: SelectionButton = {
        let button = SelectionButton(title: "Movies")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var booksButton: SelectionButton = {
        let button = SelectionButton(title: "Books")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var sportsButton: SelectionButton = {
        let button = SelectionButton(title: "Sports")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var gamesButton: SelectionButton = {
        let button = SelectionButton(title: "Games")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var talkingButton: SelectionButton = {
        let button = SelectionButton(title: "Talking")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var travelingButton: SelectionButton = {
        let button = SelectionButton(title: "Traveling")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var cookingButton: SelectionButton = {
        let button = SelectionButton(title: "Cooking")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var musicButton: SelectionButton = {
        let button = SelectionButton(title: "Music")
        button.layer.cornerRadius = 19.5
        button.addTarget(self, action: #selector(selectionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var drinkingButton: SelectionButton = {
        let button = SelectionButton(title: "Drinking")
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
        self.addSubview(hobbyQuestionLabel)
        hobbyQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(hobbyQuestionLabel).offset(-3.0)
            $0.leading.equalTo(hobbyQuestionLabel.snp.trailing).offset(6.0)
        }
        
        let stackView1 = UIStackView(
            arrangedSubviews: [
                moviesButton,
                booksButton,
                sportsButton])
        
        let stackView2 = UIStackView(
            arrangedSubviews: [
                gamesButton,
                talkingButton,
                travelingButton])
        
        let stackView3 = UIStackView(
            arrangedSubviews: [
                cookingButton,
                musicButton,
                drinkingButton])
        
        [stackView1, stackView2, stackView3].forEach { stackView in
            stackView.spacing = 19.0
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
        }
    
        self.addSubview(stackView1)
        stackView1.snp.makeConstraints {
            $0.top.equalTo(hobbyQuestionLabel.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        self.addSubview(stackView2)
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(22.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        self.addSubview(stackView3)
        stackView3.snp.makeConstraints {
            $0.top.equalTo(stackView2.snp.bottom).offset(22.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
    }
}
