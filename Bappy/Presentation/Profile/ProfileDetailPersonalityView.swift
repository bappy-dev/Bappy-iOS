//
//  ProfileDetailPersonalityView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileDetailPersonalityView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileDetailPersonalityViewModel
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
    
    private let spontaneousLabel = SelectionLabel(title: "Spontaneous")
    private let planningLabel = SelectionLabel(title: "Planning")
    private let talkativeLabel = SelectionLabel(title: "Talkative")
    private let empathicLabel = SelectionLabel(title: "Empathic")
    private let shyLabel = SelectionLabel(title: "Shy")
    private let calmLabel = SelectionLabel(title: "Calm")
    private let politeLabel = SelectionLabel(title: "Polite")
    
    // MARK: Lifecycle
    init(viewModel: ProfileDetailPersonalityViewModel) {
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
            spontaneousLabel, planningLabel,
            talkativeLabel, empathicLabel,
            shyLabel, calmLabel, politeLabel
        ] { label.layer.cornerRadius = 19.5 }
    }
    
    private func layout() {
        let firstSubviews: [UIView] = [spontaneousLabel, planningLabel]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [talkativeLabel, empathicLabel]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [shyLabel, calmLabel, politeLabel]
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
extension ProfileDetailPersonalityView {
    private func bind() {
        viewModel.output.spontaneous
            .drive(spontaneousLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.planning
            .drive(planningLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.talkative
            .drive(talkativeLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.empathic
            .drive(empathicLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shy
            .drive(shyLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.calm
            .drive(calmLabel.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.polite
            .drive(politeLabel.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
