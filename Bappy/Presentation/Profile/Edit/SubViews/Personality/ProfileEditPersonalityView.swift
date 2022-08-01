//
//  ProfileEditPersonalityView.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileEditPersonalityView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileEditPersonalityViewModel
    private let disposeBag = DisposeBag()
    
    private let personalityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_personality")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Personality"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let spontaneousButton = SelectionButton(title: "Spontaneous")
    private let planningButton = SelectionButton(title: "Planning")
    private let talkativeButton = SelectionButton(title: "Talkative")
    private let empathicButton = SelectionButton(title: "Empathic")
    private let shyButton = SelectionButton(title: "Shy")
    private let calmButton = SelectionButton(title: "Calm")
    private let politeButton = SelectionButton(title: "Polite")
    
    // MARK: Lifecycle
    init(viewModel: ProfileEditPersonalityViewModel) {
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
        for button in [
            spontaneousButton, planningButton,
            talkativeButton, empathicButton,
            shyButton, calmButton, politeButton
        ] {
            button.layer.cornerRadius = 19.5
            button.font = .roboto(size: 14.0)
        }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [spontaneousButton, planningButton]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [talkativeButton, empathicButton]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [shyButton, calmButton, politeButton]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
        
        for stackView in [firstHStackView, secondHStackView, thirdHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 15.0
            stackView.distribution = .fillEqually
        }
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView, thirdHStackView]
        let vStackView = UIStackView(arrangedSubviews: vStackSubviews)
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 12.0
        
        self.addSubview(personalityImageView)
        personalityImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31.0)
            $0.leading.equalToSuperview().inset(66.0)
            $0.width.equalTo(19.0)
            $0.height.equalTo(18.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(personalityImageView.snp.trailing).offset(6.0)
            $0.centerY.equalTo(personalityImageView)
        }
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalTo(personalityImageView.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(51.0)
            $0.trailing.equalToSuperview().inset(50.0)
            $0.height.equalTo(141.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension ProfileEditPersonalityView {
    private func bind() {
        spontaneousButton.rx.tap
            .bind(to: viewModel.input.spontaneousButtonTapped)
            .disposed(by: disposeBag)
        
        planningButton.rx.tap
            .bind(to: viewModel.input.planningButtonTapped)
            .disposed(by: disposeBag)
        
        talkativeButton.rx.tap
            .bind(to: viewModel.input.talkativeButtonTapped)
            .disposed(by: disposeBag)
        
        empathicButton.rx.tap
            .bind(to: viewModel.input.empathicButtonTapped)
            .disposed(by: disposeBag)
        
        shyButton.rx.tap
            .bind(to: viewModel.input.shyButtonTapped)
            .disposed(by: disposeBag)
        
        calmButton.rx.tap
            .bind(to: viewModel.input.calmButtonTapped)
            .disposed(by: disposeBag)
        
        politeButton.rx.tap
            .bind(to: viewModel.input.politeButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.spontaneous
            .drive(spontaneousButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.planning
            .drive(planningButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.talkative
            .drive(talkativeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.empathic
            .drive(empathicButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shy
            .drive(shyButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.calm
            .drive(calmButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.polite
            .drive(politeButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
