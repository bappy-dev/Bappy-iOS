//
//  HangoutMakeOpenchatView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeOpenchatView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeOpenchatViewModel
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let openchatCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Make Kakao chat\nor Google meet"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let openchatTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 13.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the URL or any message you wanna write.",
            attributes: [.foregroundColor: UIColor.bappyGray])
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = .rgb(241, 209, 83, 1)
        return underlinedView
    }()
    
    private let guideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Making guide",
            font: .roboto(size: 10.0),
            color: .black.withAlphaComponent(0.33),
            hasUnderline: true
        )
        return button
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Copy Bappy Openchat",
            font: .roboto(size: 10.0),
            color: .black.withAlphaComponent(0.33),
            hasUnderline: true
        )
        return button
    }()
    
    private let ruleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0)
        label.textColor = .bappyCoral
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakeOpenchatViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func updateTextFieldPosition(bottomButtonHeight: CGFloat) {
        let labelPosition = scrollView.frame.height - ruleDescriptionLabel.frame.maxY
        let y = (bottomButtonHeight > labelPosition) ? bottomButtonHeight - labelPosition + 5.0 : 0
        let offset = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        ruleDescriptionLabel.text = "Enter the URL"
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        self.addSubviews([openchatCaptionLabel, scrollView])
        scrollView.addSubview(contentView)
        contentView.addSubviews([openchatTextField, underlinedView, ruleDescriptionLabel, guideButton, copyButton])
        
        openchatCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(openchatCaptionLabel.snp.bottom).offset(5.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1000.0)
        }
        
        openchatTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
        }
        
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(openchatTextField.snp.bottom).offset(7.0)
        }
        
        guideButton.snp.makeConstraints {
            $0.top.equalTo(underlinedView.snp.bottom).offset(4.0)
            $0.trailing.equalTo(underlinedView).offset(-3.0)
        }
        
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(underlinedView.snp.bottom).offset(10.0)
            $0.leading.equalTo(underlinedView).offset(5.0)
        }
        
        copyButton.snp.makeConstraints {
            $0.trailing.equalTo(guideButton.snp.trailing)
            $0.top.equalTo(guideButton.snp.bottom).offset(5)
        }
    }
}

// MARK: - Bind
extension HangoutMakeOpenchatView {
    private func bind() {
        guideButton.rx.tap
            .debounce(RxTimeInterval.nanoseconds(1000), scheduler: MainScheduler.instance)
            .map { URL(string: Constant.instaURL) }
            .bind {
                EventLogger.logEvent("chat_guide", parameters: ["name": "HangoutMakeOpenchatView"])
                guard let url = $0 else { return }
                UIApplication.shared.open(url)
            }.disposed(by: disposeBag)

        copyButton.rx.tap
            .bind { [weak self] _ in
                let url = "https://open.kakao.com/o/goFgooSe"
                self?.viewModel.input.text.onNext(url)
                self?.openchatTextField.text = url
            }.disposed(by: disposeBag)
        
        openchatTextField.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        openchatTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideRule
            .emit(to: ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.keyboardWithButtonHeight
            .emit(onNext: { [weak self] height in
                self?.updateTextFieldPosition(bottomButtonHeight: height)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.openchatText
            .emit(to: openchatTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
