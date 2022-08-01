//
//  ProfileEditInterestsView.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileEditInterestsView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileEditInterestsViewModel
    private let disposeBag = DisposeBag()
    
    private let interestsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_interests")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Interests"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let travelButton = SelectionButton(title: "Travel")
    private let studyButton = SelectionButton(title: "Study")
    private let sportsButton = SelectionButton(title: "Sports")
    private let foodButton = SelectionButton(title: "Food")
    private let drinksButton = SelectionButton(title: "Drinks")
    private let cookButton = SelectionButton(title: "Cook")
    private let cultureButton = SelectionButton(title: "Cultural Activities")
    private let volunteerButton = SelectionButton(title: "Volunteer")
    private let languageButton = SelectionButton(title: "Practice Language")
    private let craftingButton = SelectionButton(title: "Crafting")
    
    // MARK: Lifecycle
    init(viewModel: ProfileEditInterestsViewModel) {
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
            travelButton, studyButton, sportsButton,
            foodButton, drinksButton, cookButton,
            cultureButton, volunteerButton,
            languageButton, craftingButton
        ] {
            button.layer.cornerRadius = 19.5
            button.font = .roboto(size: 14.0)
        }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [travelButton, studyButton, sportsButton]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [foodButton, drinksButton, cookButton]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [cultureButton, volunteerButton]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
         
        let fourthSubviews: [UIView] = [languageButton, craftingButton]
        let fourthHStackView = UIStackView(arrangedSubviews: fourthSubviews)
        
        for stackView in [firstHStackView, secondHStackView, thirdHStackView, fourthHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 15.0
        }
        firstHStackView.distribution = .fillEqually
        secondHStackView.distribution = .fillEqually
        thirdHStackView.distribution = .fillProportionally
        fourthHStackView.distribution = .fillProportionally
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView, thirdHStackView, fourthHStackView]
        let vStackView = UIStackView(arrangedSubviews: vStackSubviews)
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 12.0
        
        self.addSubview(interestsImageView)
        interestsImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19.0)
            $0.leading.equalToSuperview().inset(66.0)
            $0.width.equalTo(19.0)
            $0.height.equalTo(18.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(interestsImageView.snp.trailing).offset(6.0)
            $0.centerY.equalTo(interestsImageView)
        }
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalTo(interestsImageView.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(44.0)
            $0.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(192.0)
            $0.bottom.equalToSuperview().inset(55.0)
        }
        
        volunteerButton.snp.makeConstraints { $0.width.equalToSuperview().dividedBy(2.5) }
        craftingButton.snp.makeConstraints { $0.width.equalToSuperview().dividedBy(2.5) }
    }
}

// MARK: - Bind
extension ProfileEditInterestsView {
    private func bind() {
        travelButton.rx.tap
            .bind(to: viewModel.input.travelButtonTapped$)
            .disposed(by: disposeBag)
        
        studyButton.rx.tap
            .bind(to: viewModel.input.studyButtonTapped$)
            .disposed(by: disposeBag)
        
        sportsButton.rx.tap
            .bind(to: viewModel.input.sportsButtonTapped$)
            .disposed(by: disposeBag)
        
        foodButton.rx.tap
            .bind(to: viewModel.input.foodButtonTapped$)
            .disposed(by: disposeBag)
        
        drinksButton.rx.tap
            .bind(to: viewModel.input.drinksButtonTapped$)
            .disposed(by: disposeBag)
        
        cookButton.rx.tap
            .bind(to: viewModel.input.cookButtonTapped$)
            .disposed(by: disposeBag)
        
        cultureButton.rx.tap
            .bind(to: viewModel.input.cultureButtonTapped$)
            .disposed(by: disposeBag)
        
        volunteerButton.rx.tap
            .bind(to: viewModel.input.volunteerButtonTapped$)
            .disposed(by: disposeBag)
        
        languageButton.rx.tap
            .bind(to: viewModel.input.languageButtonTapped$)
            .disposed(by: disposeBag)
        
        craftingButton.rx.tap
            .bind(to: viewModel.input.craftingButtonTapped$)
            .disposed(by: disposeBag)
        
        viewModel.output.travel
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.study
            .drive(studyButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.sports
            .drive(sportsButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.food
            .drive(foodButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.drinks
            .drive(drinksButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.cook
            .drive(cookButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.culture
            .drive(cultureButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.volunteer
            .drive(volunteerButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.language
            .drive(languageButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.crafting
            .drive(craftingButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
