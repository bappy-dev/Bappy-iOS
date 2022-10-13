//
//  HangoutMakePlanView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakePlanView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakePlanViewModel
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let planCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Write a\nHangout plan"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let planTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .roboto(size: 16.0)
        textView.textColor = .bappyBrown
        textView.textAlignment = .left
        return textView
    }()
    
    private let planPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter the contents."
        label.textColor = .rgb(140, 136, 119, 1)
        label.font = .roboto(size: 16.0, family: .Light)
        label.numberOfLines = 0
        return label
    }()
    
    private let planBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .bappyLightgray
        backgroundView.layer.cornerRadius = 12.0
        return backgroundView
    }()
    
    private let ruleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0)
        label.textColor = .bappyCoral
        label.isHidden = true
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = .bappyGray
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakePlanViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc
    private func touchesScrollView() {
        planTextView.resignFirstResponder()
    }
    
    // MARK: Helpers
    private func updateTextViewPosition(bottomButtonHeight: CGFloat) {
        let labelPostion = scrollView.frame.height - ruleDescriptionLabel.frame.maxY
        let y = (bottomButtonHeight > labelPostion) ? bottomButtonHeight - labelPostion + 5.0 : 0
        let offset = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }
    
    private func configure() {
        self.backgroundColor = .white
        ruleDescriptionLabel.text = "Enter at least 14 characters"
    }
    
    private func layout() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(planCaptionLabel)
        planCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
      
        contentView.addSubview(planBackgroundView)
        planBackgroundView.snp.makeConstraints {
            $0.top.equalTo(planCaptionLabel.snp.bottom).offset(40.0)
            $0.leading.trailing.equalToSuperview().inset(43.0)
            $0.height.equalTo(138.0)
            $0.bottom.equalToSuperview().inset(50.0)
        }
        
        planBackgroundView.addSubview(planTextView)
        planTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4.0)
            $0.leading.trailing.equalToSuperview().inset(12.0)
        }

        planTextView.addSubview(planPlaceholderLabel)
        planPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(6.0)
            $0.trailing.equalToSuperview()
        }
        
        contentView.addSubview(ruleDescriptionLabel)
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(planBackgroundView.snp.bottom).offset(3.0)
            $0.leading.equalTo(planBackgroundView)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.top.equalTo(planBackgroundView.snp.bottom).offset(3.0)
            $0.trailing.equalTo(planBackgroundView).offset(-4.0)
        }
    }
}

// MARK: - Bind
extension HangoutMakePlanView {
    private func bind() {
        planTextView.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        planTextView.rx.didBeginEditing
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.modifiedText
            .emit(to: planTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.keyboardWithButtonHeight
            .emit(onNext: { [weak self] height in
                self?.updateTextViewPosition(bottomButtonHeight: height)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHidePlaceholder
            .emit(to: planPlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideRule
            .emit(to: ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.countInfo
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
