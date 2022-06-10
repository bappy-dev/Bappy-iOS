//
//  HangoutOpenchatView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

final class HangoutOpenchatView: UIView {
    
    // MARK: Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let openchatCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Make\nKakao Openchat"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var openchatTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 14.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the URL",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        textField.addTarget(self, action: #selector(textFieldEditingHandler), for: .allEditingEvents)
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        underlinedView.addBappyShadow(shadowOffsetHeight: 1.0)
        return underlinedView
    }()
    
    private let guideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Openchat guide",
                attributes: [
                    .foregroundColor: UIColor.black.withAlphaComponent(0.33),
                    .font: UIFont.roboto(size: 10.0),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]),
            for: .normal)
        return button
    }()
    
    private let ruleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0)
        label.textColor = UIColor(named: "bappy_coral")
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func updateTextFieldPosition(bottomButtonHeight: CGFloat) {
        guard openchatTextField.isFirstResponder else { return }
        let labelPosition = scrollView.frame.height - ruleDescriptionLabel.frame.maxY
        let y = (bottomButtonHeight > labelPosition) ? bottomButtonHeight - labelPosition + 5.0 : 0
        let offset = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    // MARK: Actions
    @objc
    private func textFieldEditingHandler(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let isValid = text.hasPrefix("https://open.kakao.com/o/") && (text.count == 33)
        ruleDescriptionLabel.isHidden = isValid
//        delegate?.isTitleValid(isValid)
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        ruleDescriptionLabel.text = "Write the valid URL form"
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        self.addSubview(openchatCaptionLabel)
        openchatCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(openchatCaptionLabel.snp.bottom).offset(5.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1000.0)
        }
        
        contentView.addSubview(openchatTextField)
        openchatTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
        }
        
        contentView.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(openchatTextField.snp.bottom).offset(7.0)
        }
        
        contentView.addSubview(guideButton)
        guideButton.snp.makeConstraints {
            $0.top.equalTo(underlinedView.snp.bottom).offset(4.0)
            $0.trailing.equalTo(underlinedView).offset(-3.0)
        }
        
        contentView.addSubview(ruleDescriptionLabel)
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(underlinedView.snp.bottom).offset(10.0)
            $0.leading.equalTo(underlinedView).offset(5.0)
        }
    }
}
