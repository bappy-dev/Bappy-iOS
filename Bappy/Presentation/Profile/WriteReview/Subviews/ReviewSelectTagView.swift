//
//  ReviewSelectTagView.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReviewSelectTagView: UIView {
    
    // MARK: Properties
    private let viewModel: ReviewSelectTagViewModel
    private let disposeBag = DisposeBag()
    
    private let againButton = SelectionButton(title: Reference.Tag.Again.description, isSmall: true)
    private let friendlyButton = SelectionButton(title: Reference.Tag.Friendly.description, isSmall: true)
    private let respectfulButton = SelectionButton(title: Reference.Tag.Respectful.description, isSmall: true)
    private let talkativeButton = SelectionButton(title: Reference.Tag.Talkative.description, isSmall: true)
    private let punctualButton = SelectionButton(title: Reference.Tag.Punctual.description, isSmall: true)
    private let rudeButton = SelectionButton(title: Reference.Tag.Rude.description, isSmall: true)
    private let notAgainButton = SelectionButton(title: Reference.Tag.NotAgain.description, isSmall: true)
    private let didntMeetButton = SelectionButton(title: Reference.Tag.DidntMeet.description, isSmall: true)
    
    private let setTagsSubject = PublishSubject<[String]>()
    
    // MARK: Lifecycle
    init(viewModel: ReviewSelectTagViewModel) {
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
    func setTags(_ tags: [String]) {
        Observable.just(tags.contains(where: { $0 == Reference.Tag.Again.description }))
            .bind(to: againButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.Friendly.description }))
            .bind(to: friendlyButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.Respectful.description }))
            .bind(to: respectfulButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.Talkative.description }))
            .bind(to: talkativeButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.Punctual.description }))
            .bind(to: punctualButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.Rude.description }))
            .bind(to: rudeButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.NotAgain.description }))
            .bind(to: notAgainButton.rx.isSelected)
            .disposed(by: disposeBag)
        Observable.just(tags.contains(where: { $0 == Reference.Tag.DidntMeet.description }))
            .bind(to: didntMeetButton.rx.isSelected)
            .disposed(by: disposeBag)
        setTagsSubject.onNext(tags)
    }
    
    private func configure() {
        self.backgroundColor = .white
        for button in [
            againButton, friendlyButton, respectfulButton,
            talkativeButton, punctualButton, rudeButton,
            notAgainButton, didntMeetButton
        ] { button.layer.cornerRadius = 19.5 }
    }
    
    private func layout() {
        let firstHStackView = UIStackView(arrangedSubviews: [againButton, friendlyButton, respectfulButton, talkativeButton])
        let secondHStackView = UIStackView(arrangedSubviews: [punctualButton, rudeButton, notAgainButton, didntMeetButton])
        
        for stackView in [firstHStackView, secondHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 6.0
            stackView.distribution = .fillProportionally
        }
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView]
        let vStackView = UIStackView(arrangedSubviews: vStackSubviews)
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 9.0
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(39.0 * 2 + 9.0)
        }
    }
}

// MARK: - Bind
extension ReviewSelectTagView {
    private func bind() {
        againButton.rx.tap
            .bind(to: viewModel.input.againButtonTapped)
            .disposed(by: disposeBag)
        friendlyButton.rx.tap
            .bind(to: viewModel.input.friendlyButtonTapped)
            .disposed(by: disposeBag)
        respectfulButton.rx.tap
            .bind(to: viewModel.input.respectfulButtonTapped)
            .disposed(by: disposeBag)
        talkativeButton.rx.tap
            .bind(to: viewModel.input.talkativeButtonTapped)
            .disposed(by: disposeBag)
        punctualButton.rx.tap
            .bind(to: viewModel.input.punctualButtonTapped)
            .disposed(by: disposeBag)
        rudeButton.rx.tap
            .bind(to: viewModel.input.rudeButtonTapped)
            .disposed(by: disposeBag)
        notAgainButton.rx.tap
            .bind(to: viewModel.input.notAgainButtonTapped)
            .disposed(by: disposeBag)
        didntMeetButton.rx.tap
            .bind(to: viewModel.input.didntMeetButtonTapped)
            .disposed(by: disposeBag)
        setTagsSubject
            .bind(to: viewModel.input.setTags)
            .disposed(by: disposeBag)
        
        viewModel.output.isAgainButtonEnabled
            .drive(againButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isFriendlyButtonEnabled
            .drive(friendlyButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isRespectfulButtonEnabled
            .drive(respectfulButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isTalkativeButtonEnabled
            .drive(talkativeButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isPunctualButtonEnabled
            .drive(punctualButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isRudeButtonEnabled
            .drive(rudeButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isNotAgainButtonEnabled
            .drive(notAgainButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isDidntMeetButtonEnabled
            .drive(didntMeetButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
