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
    
    private let backButton = UIButton()
    private let progressBarView = ProgressBarView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let continueButtonView: ContinueButtonView

    // MARK: Lifecycle
    init(viewModel: WriteReviewViewModel) {
        let continueButtonViewModel = viewModel.subViewModels.continueButtonViewModel
        
        self.viewModel = viewModel
        self.continueButtonView = ContinueButtonView(viewModel: continueButtonViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
        addTapGestureOnScrollView()
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
    
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }

    private func configure() {
        view.backgroundColor = .white
        backButton.setImage(UIImage(named: "chevron_back"), for: .normal)
        backButton.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(5.5)
            $0.width.height.equalTo(44.0)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
//        view.addSubview(categoryView)
//        categoryView.snp.makeConstraints {
//            $0.top.leading.bottom.equalTo(contentView)
//            $0.width.equalTo(view.frame.width)
//        }
        
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

