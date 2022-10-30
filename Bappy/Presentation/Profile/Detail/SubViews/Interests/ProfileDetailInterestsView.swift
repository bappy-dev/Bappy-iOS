//
//  ProfileDetailInterestsView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileDetailInterestsView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileDetailInterestsViewModel
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
    
    private let travelLabel = SelectionLabel(title: "Travel")
    private let cafeLabel = SelectionLabel(title: "Cafe")
    private let hikingLabel = SelectionLabel(title: "Hiking")
    private let foodLabel = SelectionLabel(title: "Food")
    private let barLabel = SelectionLabel(title: "Bar")
    private let cookLabel = SelectionLabel(title: "Cook")
    private let shoppingLabel = SelectionLabel(title: "Shopping")
    private let volunteerLabel = SelectionLabel(title: "Volunteer")
    private let languageLabel = SelectionLabel(title: "Practice Language")
    private let craftingLabel = SelectionLabel(title: "Crafting")
    private let ballGameLabel = SelectionLabel(title: "Ball Game")
    private let runningLabel = SelectionLabel(title: "Running")
    private let concertsLabel = SelectionLabel(title: "Concerts")
    private let museumLabel = SelectionLabel(title: "Museum")
    private let veganLabel = SelectionLabel(title: "Vegan")
    private let boardgameLabel = SelectionLabel(title: "Boardgame")
    private let musicLabel = SelectionLabel(title: "Music")
    
    // MARK: Lifecycle
    init(viewModel: ProfileDetailInterestsViewModel) {
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
        for label in [
            travelLabel, cafeLabel, hikingLabel,
            foodLabel, barLabel, cookLabel,
            shoppingLabel, volunteerLabel,
            languageLabel, craftingLabel,
            ballGameLabel, runningLabel, concertsLabel,
            museumLabel, veganLabel, boardgameLabel, musicLabel
        ] { label.layer.cornerRadius = 19.5 }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [travelLabel, cafeLabel, hikingLabel]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [foodLabel, barLabel, cookLabel]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [shoppingLabel, musicLabel, volunteerLabel]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
         
        let fourthSubviews: [UIView] = [languageLabel, craftingLabel]
        let fourthHStackView = UIStackView(arrangedSubviews: fourthSubviews)
        
        let fifthSubviews: [UIView] = [ballGameLabel, veganLabel, runningLabel]
        let fifthHStackView = UIStackView(arrangedSubviews: fifthSubviews)
        
        let sixthSubviews: [UIView] = [concertsLabel, museumLabel, boardgameLabel]
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
            $0.height.equalTo(39 * vStackSubviews.count + (vStackSubviews.count - 1) * 12)
            $0.bottom.equalToSuperview().inset(55.0)
        }
        
        volunteerLabel.snp.makeConstraints { $0.width.equalToSuperview().dividedBy(2.5) }
        craftingLabel.snp.makeConstraints { $0.width.equalToSuperview().dividedBy(2.5) }
    }
}

// MARK: - Bind
extension ProfileDetailInterestsView {
    private func bind() {
        viewModel.output.travel
            .drive(travelLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.cafe
            .drive(cafeLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.hiking
            .drive(hikingLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.food
            .drive(foodLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.bar
            .drive(barLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.cook
            .drive(cookLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shopping
            .drive(shoppingLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.volunteer
            .drive(volunteerLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.language
            .drive(languageLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.crafting
            .drive(craftingLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.music
            .drive(musicLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.ballgame
            .drive(ballGameLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.vegan
            .drive(veganLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.running
            .drive(runningLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.concerts
            .drive(concertsLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.museum
            .drive(museumLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.boardgame
            .drive(boardgameLabel.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
