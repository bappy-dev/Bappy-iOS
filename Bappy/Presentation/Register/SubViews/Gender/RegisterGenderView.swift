//
//  RegisterGenderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Accelerate

final class RegisterGenderView: UIView {
    
    // MARK: Properties
    private let viewModel: RegisterGenderViewModel
    private let disposeBag = DisposeBag()
    
    private let genderCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "What's\nyour gender"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let maleButton = SelectionButton(title: "Male")
    private let femaleButton = SelectionButton(title: "Female")
    private let otherButton = SelectionButton(title: "Other")

    
    // MARK: Lifecycle
    init(viewModel: RegisterGenderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        maleButton.layer.cornerRadius = 19.5
        femaleButton.layer.cornerRadius = 19.5
        otherButton.layer.cornerRadius = 19.5
    }
    
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

// MARK: - Bind
extension RegisterGenderView {
    private func bind() {
        maleButton.rx.tap
            .bind(to: viewModel.input.maleButtonTapped)
            .disposed(by: disposeBag)
        
        femaleButton.rx.tap
            .bind(to: viewModel.input.femaleButtonTapped)
            .disposed(by: disposeBag)
        
        otherButton.rx.tap
            .bind(to: viewModel.input.otherButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isMaleSelected
            .bind(to: maleButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.isFemaleSelected
            .bind(to: femaleButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.isOtherSelected
            .bind(to: otherButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        
    }
}
