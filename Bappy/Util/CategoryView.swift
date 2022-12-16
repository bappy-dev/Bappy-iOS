//
//  CategoryView.swift
//  Bappy
//
//  Created by 이현욱 on 2022/12/10.
//

import UIKit

import RxCocoa
import RxSwift

class CategoryView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel: CategoryViewModel
    
    private let travelButton = SelectionButton(title: "Travel")
    private let eat_outButton = SelectionButton(title: "Eat out")
    private let cafeButton = SelectionButton(title: "Cafe")
    private let cookingButton = SelectionButton(title: "Cooking")
    private let veganButton = SelectionButton(title: "Vegan")
    private let barButton = SelectionButton(title: "Bar")
    
    private let languageButton = SelectionButton(title: "Language Practice")
    private let discussionButton = SelectionButton(title: "Discussion")
    private let danceButton = SelectionButton(title: "Dance")
    private let kpopButton = SelectionButton(title: "K-POP")
    private let studyButton = SelectionButton(title: "Study")
    private let readButton = SelectionButton(title: "Read")
    private let instrumentsButton = SelectionButton(title: "Instruments")
    private let drawButton = SelectionButton(title: "Draw")
    
    private let movieButton = SelectionButton(title: "Movie")
    private let exhibitionButton = SelectionButton(title: "Exhibition")
    private let museumButton = SelectionButton(title: "Museum")
    private let festivalButton = SelectionButton(title: "Festival")
    private let concertsButton = SelectionButton(title: "Concerts")
    private let partyButton = SelectionButton(title: "Party")
    private let picnicButton = SelectionButton(title: "Picnic")
    private let boardgameButton = SelectionButton(title: "Boardgame")
    private let sportsButton = SelectionButton(title: "Sports")
   
    private let volunteerButton = SelectionButton(title: "Volunteer")
    private let projcetsButton = SelectionButton(title: "Projcets")
    private let careerButton = SelectionButton(title: "Career")

    // MARK: Lifecycle
    init(viewModel: CategoryViewModel) {
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
            travelButton, eat_outButton, cafeButton,
            cookingButton, veganButton, barButton,
            languageButton, discussionButton,
            danceButton, kpopButton, studyButton,
            readButton, instrumentsButton, drawButton,
            movieButton, exhibitionButton, museumButton,
            festivalButton, concertsButton, partyButton,
            picnicButton, boardgameButton, sportsButton,
            volunteerButton, projcetsButton, careerButton
        ] {
            button.smalling = viewModel.dependency.isSmall
            button.isEnabled = viewModel.dependency.isEnabled
            button.layer.cornerRadius = 19.5
        }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [travelButton, eat_outButton, cafeButton]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [cookingButton, veganButton, barButton]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        let firstSepe = UIView()
        
        let thirdSubviews: [UIView] = [languageButton, discussionButton]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
        
        let fourthSubviews: [UIView] = [danceButton, kpopButton, studyButton]
        let fourthHStackView = UIStackView(arrangedSubviews: fourthSubviews)
        
        let fifthSubviews: [UIView] = [readButton, instrumentsButton, drawButton]
        let fifthHStackView = UIStackView(arrangedSubviews: fifthSubviews)
        let secSepe = UIView()
        
        let sixthSubviews: [UIView] = [movieButton, exhibitionButton, museumButton]
        let sixthHStackView = UIStackView(arrangedSubviews: sixthSubviews)
        
        let seventhSubviews: [UIView] = [festivalButton, concertsButton, partyButton]
        let seventhHStackView = UIStackView(arrangedSubviews: seventhSubviews)
        
        let eighthSubviews: [UIView] = [picnicButton, boardgameButton, sportsButton]
        let eighthHStackView = UIStackView(arrangedSubviews: eighthSubviews)
        let thirdSepe = UIView()
        
        let ninethSubviews: [UIView] = [volunteerButton, projcetsButton, careerButton]
        let ninethHStackView = UIStackView(arrangedSubviews: ninethSubviews)
        
        for stackView in [firstHStackView, secondHStackView, thirdHStackView, fourthHStackView, fifthHStackView, sixthHStackView, seventhHStackView, eighthHStackView, ninethHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 15.0
            
            stackView.snp.makeConstraints {
                $0.height.equalTo(39)
            }
        }
        
        firstHStackView.distribution = .fillEqually
        secondHStackView.distribution = .fillEqually
        thirdHStackView.distribution = .fillProportionally
        fourthHStackView.distribution = .fillProportionally
        fifthHStackView.distribution = .fillProportionally
        sixthHStackView.distribution = .fillProportionally
        seventhHStackView.distribution = .fillProportionally
        eighthHStackView.distribution = .fillProportionally
        ninethHStackView.distribution = .fillProportionally
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView, firstSepe, thirdHStackView, fourthHStackView, fifthHStackView, secSepe, sixthHStackView, seventhHStackView, eighthHStackView, thirdSepe, ninethHStackView]
        let vStackView = UIStackView(arrangedSubviews: vStackSubviews)
        vStackView.axis = .vertical
        vStackView.distribution = .fillProportionally
        vStackView.spacing = 8.0
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.height.equalTo(442)
            $0.edges.equalToSuperview()
        }
        
        for view in [firstSepe, secSepe, thirdSepe] {
            view.snp.makeConstraints {
                $0.height.equalTo(1)
            }
        }
    }
}

// MARK: - Bind
extension CategoryView {
    private func bind() {
        travelButton.rx.tap
            .bind(to: viewModel.input.travelButtonTapped)
            .disposed(by: disposeBag)
        eat_outButton.rx.tap
            .bind(to: viewModel.input.eat_outButtonTapped)
            .disposed(by: disposeBag)
        cafeButton.rx.tap
            .bind(to: viewModel.input.cafeButtonTapped)
            .disposed(by: disposeBag)
        cookingButton.rx.tap
            .bind(to: viewModel.input.cookingButtonTapped)
            .disposed(by: disposeBag)
        veganButton.rx.tap
            .bind(to: viewModel.input.veganButtonTapped)
            .disposed(by: disposeBag)
        barButton.rx.tap
            .bind(to: viewModel.input.barButtonTapped)
            .disposed(by: disposeBag)
        languageButton.rx.tap
            .bind(to: viewModel.input.languageButtonTapped)
            .disposed(by: disposeBag)
        discussionButton.rx.tap
            .bind(to: viewModel.input.discussionButtonTapped)
            .disposed(by: disposeBag)
        danceButton.rx.tap
            .bind(to: viewModel.input.danceButtonTapped)
            .disposed(by: disposeBag)
        kpopButton.rx.tap
            .bind(to: viewModel.input.kpopButtonTapped)
            .disposed(by: disposeBag)
        studyButton.rx.tap
            .bind(to: viewModel.input.studyButtonTapped)
            .disposed(by: disposeBag)
        readButton.rx.tap
            .bind(to: viewModel.input.readButtonTapped)
            .disposed(by: disposeBag)
        instrumentsButton.rx.tap
            .bind(to: viewModel.input.instrumentsButtonTapped)
            .disposed(by: disposeBag)
        drawButton.rx.tap
            .bind(to: viewModel.input.drawButtonTapped)
            .disposed(by: disposeBag)
        movieButton.rx.tap
            .bind(to: viewModel.input.movieButtonTapped)
            .disposed(by: disposeBag)
        exhibitionButton.rx.tap
            .bind(to: viewModel.input.exhibitionButtonTapped)
            .disposed(by: disposeBag)
        museumButton.rx.tap
            .bind(to: viewModel.input.museumButtonTapped)
            .disposed(by: disposeBag)
        festivalButton.rx.tap
            .bind(to: viewModel.input.festivalButtonTapped)
            .disposed(by: disposeBag)
        concertsButton.rx.tap
            .bind(to: viewModel.input.concertsButtonTapped)
            .disposed(by: disposeBag)
        partyButton.rx.tap
            .bind(to: viewModel.input.partyButtonTapped)
            .disposed(by: disposeBag)
        picnicButton.rx.tap
            .bind(to: viewModel.input.picnicButtonTapped)
            .disposed(by: disposeBag)
        boardgameButton.rx.tap
            .bind(to: viewModel.input.boardgameButtonTapped)
            .disposed(by: disposeBag)
        sportsButton.rx.tap
            .bind(to: viewModel.input.sportsButtonTapped)
            .disposed(by: disposeBag)
        careerButton.rx.tap
            .bind(to: viewModel.input.careerButtonTapped)
            .disposed(by: disposeBag)
        projcetsButton.rx.tap
            .bind(to: viewModel.input.projcetsButtonTapped)
            .disposed(by: disposeBag)
        volunteerButton.rx.tap
            .bind(to: viewModel.input.volunteerButtonTapped)
            .disposed(by: disposeBag)

        viewModel.output.travel
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.eat_out
            .drive(eat_outButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.cafe
            .drive(cafeButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.cooking
            .drive(cookingButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.draw
            .drive(drawButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.vegan
            .drive(veganButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.bar
            .drive(barButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.language
            .drive(languageButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.discussion
            .drive(discussionButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.dance
            .drive(danceButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.kpop
            .drive(kpopButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.study
            .drive(studyButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.read
            .drive(readButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.instruments
            .drive(instrumentsButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.movie
            .drive(movieButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.exhibition
            .drive(exhibitionButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.museum
            .drive(museumButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.festival
            .drive(festivalButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.concerts
            .drive(concertsButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.party
            .drive(partyButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.picnic
            .drive(picnicButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.boardgame
            .drive(boardgameButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.sports
            .drive(sportsButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.volunteer
            .drive(volunteerButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.projcets
            .drive(projcetsButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.output.career
            .drive(careerButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
