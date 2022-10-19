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
    private let cafeButton = SelectionButton(title: "Cafe")
    private let hikingButton = SelectionButton(title: "Hiking")
    private let foodButton = SelectionButton(title: "Food")
    private let barButton = SelectionButton(title: "Bar")
    private let cookButton = SelectionButton(title: "Cook")
    private let shoppingButton = SelectionButton(title: "Shopping")
    private let volunteerButton = SelectionButton(title: "Volunteer")
    private let languageButton = SelectionButton(title: "Practice Language")
    private let craftingButton = SelectionButton(title: "Crafting")
    private let ballGameButton = SelectionButton(title: "Ball Game")
    private let runningButton = SelectionButton(title: "Running")
    private let concertsButton = SelectionButton(title: "Concerts")
    private let museumButton = SelectionButton(title: "Museum")
    private let veganButton = SelectionButton(title: "Vegan")
    private let boardgameButton = SelectionButton(title: "Boardgame")
    private let musicButton = SelectionButton(title: "Music")
    
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
            travelButton, cafeButton, hikingButton,
            foodButton, barButton, cookButton,
            shoppingButton, volunteerButton,
            languageButton, craftingButton,
            ballGameButton, runningButton, concertsButton,
            museumButton, veganButton,
            boardgameButton, musicButton
        ] { button.layer.cornerRadius = 19.5 }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [travelButton, cafeButton, hikingButton]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [foodButton, barButton, cookButton]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [shoppingButton, musicButton, volunteerButton]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
        
        let fourthSubviews: [UIView] = [languageButton, craftingButton]
        let fourthHStackView = UIStackView(arrangedSubviews: fourthSubviews)
        
        let fifthSubviews: [UIView] = [ballGameButton, veganButton, runningButton]
        let fifthHStackView = UIStackView(arrangedSubviews: fifthSubviews)
        
        let sixthSubviews: [UIView] = [concertsButton, museumButton,  boardgameButton]
        let sixthHStackView = UIStackView(arrangedSubviews: sixthSubviews)
        
        for stackView in [firstHStackView, secondHStackView, thirdHStackView, fourthHStackView, fifthHStackView, sixthHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 15.0
        }
        firstHStackView.distribution = .fillEqually
        secondHStackView.distribution = .fillEqually
        thirdHStackView.distribution = .fillProportionally
        fourthHStackView.distribution = .fillProportionally
        fifthHStackView.distribution = .fillProportionally
        sixthHStackView.distribution = .fillProportionally
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView, thirdHStackView, fourthHStackView, fifthHStackView, sixthHStackView]
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
            $0.height.equalTo(39.0 * 6 + 12.0 * 3)
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
        cafeButton.rx.tap
            .bind(to: viewModel.input.cafeButtonTapped)
            .disposed(by: disposeBag)
        hikingButton.rx.tap
            .bind(to: viewModel.input.hikingButtonTapped)
            .disposed(by: disposeBag)
        foodButton.rx.tap
            .bind(to: viewModel.input.foodButtonTapped)
            .disposed(by: disposeBag)
        barButton.rx.tap
            .bind(to: viewModel.input.barButtonTapped)
            .disposed(by: disposeBag)
        cookButton.rx.tap
            .bind(to: viewModel.input.cookButtonTapped)
            .disposed(by: disposeBag)
        shoppingButton.rx.tap
            .bind(to: viewModel.input.shoppingButtonTapped)
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
        ballGameButton.rx.tap
            .bind(to: viewModel.input.ballGameButtonTapped)
            .disposed(by: disposeBag)
        musicButton.rx.tap
            .bind(to: viewModel.input.musicButtonTapped)
            .disposed(by: disposeBag)
        veganButton.rx.tap
            .bind(to: viewModel.input.veganButtonTapped)
            .disposed(by: disposeBag)
        runningButton.rx.tap
            .bind(to: viewModel.input.runningButtonTapped)
            .disposed(by: disposeBag)
        concertsButton.rx.tap
            .bind(to: viewModel.input.concertsButtonTapped)
            .disposed(by: disposeBag)
        museumButton.rx.tap
            .bind(to: viewModel.input.museumButtonTapped)
            .disposed(by: disposeBag)
        boardgameButton.rx.tap
            .bind(to: viewModel.input.boardgameButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isTravelButtonEnabled
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isCafeButtonEnabled
            .drive(cafeButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isHikingButtonEnabled
            .drive(hikingButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isFoodButtonEnabled
            .drive(foodButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isBarButtonEnabled
            .drive(barButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isCookButtonEnabled
            .drive(cookButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isShoppingButtonEnabled
            .drive(shoppingButton.rx.isSelected)
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
        viewModel.output.musicButtonEnabled
            .drive(musicButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.ballGameButtonEnabled
            .drive(ballGameButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.veganButtonEnabled
            .drive(veganButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.runningButtonEnabled
            .drive(runningButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.concertsButtonEnabled
            .drive(concertsButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.museumButtonEnabled
            .drive(museumButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.boardgameButtonEnabled
            .drive(boardgameButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideRule
            .drive(ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
