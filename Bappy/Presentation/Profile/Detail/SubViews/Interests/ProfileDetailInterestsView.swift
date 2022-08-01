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
    private let studyLabel = SelectionLabel(title: "Study")
    private let sportsLabel = SelectionLabel(title: "Sports")
    private let foodLabel = SelectionLabel(title: "Food")
    private let drinksLabel = SelectionLabel(title: "Drinks")
    private let cookLabel = SelectionLabel(title: "Cook")
    private let cultureLabel = SelectionLabel(title: "Cultural Activities")
    private let volunteerLabel = SelectionLabel(title: "Volunteer")
    private let languageLabel = SelectionLabel(title: "Practice Language")
    private let craftingLabel = SelectionLabel(title: "Crafting")
    
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
            travelLabel, studyLabel, sportsLabel,
            foodLabel, drinksLabel, cookLabel,
            cultureLabel, volunteerLabel,
            languageLabel, craftingLabel
        ] { label.layer.cornerRadius = 19.5 }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [travelLabel, studyLabel, sportsLabel]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [foodLabel, drinksLabel, cookLabel]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [cultureLabel, volunteerLabel]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
         
        let fourthSubviews: [UIView] = [languageLabel, craftingLabel]
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
        
        viewModel.output.study
            .drive(studyLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.sports
            .drive(sportsLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.food
            .drive(foodLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.drinks
            .drive(drinksLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.cook
            .drive(cookLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.culture
            .drive(cultureLabel.rx.isSelected)
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
    }
}
