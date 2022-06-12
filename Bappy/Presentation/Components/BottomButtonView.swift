//
//  BottomButtonView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BottomButtonView: UIView {
    
    // MARK: Properties
    private let viewModel: BottomButtonViewModel
    private let disposeBag = DisposeBag()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.tintColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        button.setAttributedTitle(
            NSAttributedString(
                string: " Back",
                attributes: [.font: UIFont.roboto(size: 12.0, family: .Medium)
                ]), for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.tintColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        button.semanticContentAttribute = .forceRightToLeft
        button.setAttributedTitle(
            NSAttributedString(
                string: "Tap To Continue  ",
                attributes: [.font: UIFont.roboto(size: 12.0, family: .Medium)
                ]), for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    init(viewModel: BottomButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        bind()
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func bind() {
        previousButton.rx.tap
            .bind(to: viewModel.input.didTapPreviousButton)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: viewModel.input.didTapNextButton)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(previousButton)
        previousButton.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(31.0)
        }
        
        self.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(39.0)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(55.0)
        }
    }
}

// MARK: Binder
//extension Reactive where Base: BottomButtonView {
//    var isNextButtonActivated: Binder<Bool> {
//        return Binder(self.base) { progressBarView, progression in
//            progressBarView.updateProgression(progression)
//        }
//    }
//}

//// MARK: Binder
//extension Reactive where Base: BottomButtonView {
//    var nextButtonTap: ControlEvent<Void> {
//        return ControlEvent
//    }
//}

