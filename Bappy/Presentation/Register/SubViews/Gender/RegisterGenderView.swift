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
    private let genderCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "What's\nyour gender"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
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
        let stackView = UIStackView(arrangedSubviews: [maleButton, femaleButton, otherButton])
        stackView.spacing = 19.0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        self.addSubview(genderCaptionLabel)
        genderCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
   
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(genderCaptionLabel.snp.bottom).offset(80.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
    }
}
