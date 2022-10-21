//
//  WriteReviewViewController.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WriteReviewViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: WriteReviewViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Review"
        return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .bappyGray
        divider.snp.makeConstraints { make in
            make.height.equalTo(1.0)
        }
        return divider
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = .bappyBrown
        label.text = "References make people behave and\nmake BAPPY a safer community."
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let targetsScrollView = UIScrollView()
    private let progressBarView = ProgressBarView()
    
    private let tagsView: ReviewSelectTagView
    
    private let backButton = UIButton()
    
    private let continueButtonView: ContinueButtonView

    // MARK: Lifecycle
    init(viewModel: WriteReviewViewModel) {
        self.viewModel = viewModel
        self.continueButtonView = ContinueButtonView(viewModel: viewModel.subViewModels.continueButtonViewModel)
        self.tagsView = ReviewSelectTagView(viewModel: viewModel.subViewModels.reviewSelectTagViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }

    @objc
    private func touchesScrollView() {
        view.endEditing(true)
    }

    // MARK: Helpers
    private func updateButtonPostion(keyboardHeight: CGFloat) {
        let bottomPadding = (keyboardHeight != 0) ? view.safeAreaInsets.bottom : view.safeAreaInsets.bottom * 2.0 / 3.0

        UIView.animate(withDuration: 0.4) {
            self.continueButtonView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomPadding - keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
        backButton.setImage(UIImage(named: "chevron_back"), for: .normal)
        backButton.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
    }
    
    private func layout() {
//        view.addSubview(backButton)
//        backButton.snp.makeConstraints {
//            $0.top.equalTo(progressBarView.snp.bottom).offset(15.0)
//            $0.leading.equalToSuperview().inset(5.5)
//            $0.width.height.equalTo(44.0)
//        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18.0)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(30.0)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(targetsScrollView)
        targetsScrollView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48.0)
        }
        
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints { make in
            make.top.equalTo(targetsScrollView.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(23.0)
        }
        
        view.addSubview(tagsView)
        tagsView.snp.makeConstraints { make in
            make.top.equalTo(progressBarView.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        view.addSubview(continueButtonView)
        continueButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(bottomPadding * 2.0 / 3.0)
        }
    }
}

// MARK: - Bind
extension WriteReviewViewController {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        self.rx.viewDidAppear
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldKeyboardHide
            .emit(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.progression
            .skip(1)
            .drive(progressBarView.rx.setProgression)
            .disposed(by: disposeBag)
        
        viewModel.output.initProgression
            .emit(to: progressBarView.rx.initProgression)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                self?.updateButtonPostion(keyboardHeight: height)
            })
            .disposed(by: disposeBag)
        
//        RxKeyboard.instance.visibleHeight
//            .map { [weak self] height in
//                return height + (self?.continueButtonView.frame.height ?? 0)
//            }
//            .drive(viewModel.input.keyboardWithButtonHeight)
//            .disposed(by: disposeBag)
    }
}

