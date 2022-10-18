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
            travelButton, cafeButton, hikingButton,
            foodButton, barButton, cookButton,
            shoppingButton, volunteerButton,
            languageButton, craftingButton,
            ballGameButton, runningButton, concertsButton,
            museumButton, veganButton,
            boardgameButton, musicButton
        ] {
            button.layer.cornerRadius = 19.5
            button.font = .roboto(size: 14.0)
        }
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
            $0.height.equalTo(39.0 * 6 + 12.0 * 3)
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
        
        cafeButton.rx.tap
            .bind(to: viewModel.input.cafeButtonTapped$)
            .disposed(by: disposeBag)
        
        hikingButton.rx.tap
            .bind(to: viewModel.input.hikingButtonTapped$)
            .disposed(by: disposeBag)
        
        foodButton.rx.tap
            .bind(to: viewModel.input.foodButtonTapped$)
            .disposed(by: disposeBag)
        
        barButton.rx.tap
            .bind(to: viewModel.input.barButtonTapped$)
            .disposed(by: disposeBag)
        
        cookButton.rx.tap
            .bind(to: viewModel.input.cookButtonTapped$)
            .disposed(by: disposeBag)
        
        shoppingButton.rx.tap
            .bind(to: viewModel.input.shoppingButtonTapped$)
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
        
        ballGameButton.rx.tap
            .bind(to: viewModel.input.ballGameButtonTapped$)
            .disposed(by: disposeBag)
        
        musicButton.rx.tap
            .bind(to: viewModel.input.musicButtonTapped$)
            .disposed(by: disposeBag)
        
        veganButton.rx.tap
            .bind(to: viewModel.input.veganButtonTapped$)
            .disposed(by: disposeBag)
        
        runningButton.rx.tap
            .bind(to: viewModel.input.runningButtonTapped$)
            .disposed(by: disposeBag)
        
        concertsButton.rx.tap
            .bind(to: viewModel.input.concertsButtonTapped$)
            .disposed(by: disposeBag)
        
        museumButton.rx.tap
            .bind(to: viewModel.input.museumButtonTapped$)
            .disposed(by: disposeBag)
        
        boardgameButton.rx.tap
            .bind(to: viewModel.input.boardgameButtonTapped$)
            .disposed(by: disposeBag)
        
        viewModel.output.travel
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.cafe
            .drive(cafeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.hiking
            .drive(hikingButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.food
            .drive(foodButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.bar
            .drive(barButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.cook
            .drive(cookButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shopping
            .drive(shoppingButton.rx.isSelected)
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
        
        viewModel.output.music
            .drive(musicButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.ballgame
            .drive(ballGameButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.vegan
            .drive(veganButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.running
            .drive(runningButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.concerts
            .drive(concertsButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.museum
            .drive(museumButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.boardgame
            .drive(boardgameButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
