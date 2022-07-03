//
//  HangoutMakeCategoryView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum HangoutCategory: String {
    case Travel, Study, Sports, Food, Drinks, Cook, Culture, Volunteer, Language, Crafting
}

final class HangoutMakeCategoryView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeCategoryViewModel
    private let disposeBag = DisposeBag()
    
    private let categoryCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select your\nhangout category!"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let ruleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0)
        label.textColor = .bappyCoral
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
    init(viewModel: HangoutMakeCategoryViewModel) {
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
        ruleDescriptionLabel.text = "Select at least one category"
        for button in [
            travelButton, studyButton, sportsButton,
            foodButton, drinksButton, cookButton,
            cultureButton, volunteerButton,
            languageButton, craftingButton
        ] { button.layer.cornerRadius = 19.5 }
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
        
        self.addSubview(categoryCaptionLabel)
        categoryCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(50.0)
        }
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalTo(categoryCaptionLabel.snp.bottom).offset(60.0)
            $0.leading.trailing.equalToSuperview().inset(39.0)
            $0.height.equalTo(39.0 * 4 + 12.0 * 2)
        }
        
        volunteerButton.snp.makeConstraints { $0.width.equalToSuperview().dividedBy(2.5) }
        craftingButton.snp.makeConstraints { $0.width.equalToSuperview().dividedBy(2.5) }
        
        self.addSubview(ruleDescriptionLabel)
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(15.0)
            $0.leading.equalTo(vStackView).offset(12.0)
        }
    }
}

// MARK: - Bind
extension HangoutMakeCategoryView {
    private func bind() {
        travelButton.rx.tap
            .bind(to: viewModel.input.travelButtonTapped)
            .disposed(by: disposeBag)
        studyButton.rx.tap
            .bind(to: viewModel.input.studyButtonTapped)
            .disposed(by: disposeBag)
        sportsButton.rx.tap
            .bind(to: viewModel.input.sportsButtonTapped)
            .disposed(by: disposeBag)
        foodButton.rx.tap
            .bind(to: viewModel.input.foodButtonTapped)
            .disposed(by: disposeBag)
        drinksButton.rx.tap
            .bind(to: viewModel.input.drinksButtonTapped)
            .disposed(by: disposeBag)
        cookButton.rx.tap
            .bind(to: viewModel.input.cookButtonTapped)
            .disposed(by: disposeBag)
        cultureButton.rx.tap
            .bind(to: viewModel.input.cultureButtonTapped)
            .disposed(by: disposeBag)
        volunteerButton.rx.tap
            .bind(to: viewModel.input.volunteerButtonTapped)
            .disposed(by: disposeBag)
        languageButton.rx.tap
            .bind(to: viewModel.input.languageButtonTapped)
            .disposed(by: disposeBag)
        craftingButton.rx.tap
            .bind(to: viewModel.input.craftingButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isTravelButtonEnabled
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isStudyButtonEnabled
            .drive(studyButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isSportsButtonEnabled
            .drive(sportsButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isFoodButtonEnabled
            .drive(foodButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isDrinksButtonEnabled
            .drive(drinksButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isCookButtonEnabled
            .drive(cookButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isCultureButtonEnabled
            .drive(cultureButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isVolunteerButtonEnabled
            .drive(volunteerButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isLanguageButtonEnabled
            .drive(languageButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isCraftingButtonEnabled
            .drive(craftingButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideRule
            .drive(ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
