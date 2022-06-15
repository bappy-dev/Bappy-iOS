//
//  HangoutPlanView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

final class HangoutPlanView: UIView {
    
    // MARK: Properties
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
    
    private lazy var planTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .roboto(size: 16.0)
        textView.textColor = .bappyBrown
        textView.textAlignment = .left
        textView.delegate = self
        return textView
    }()
    
    private let planPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter the contents."
        label.textColor = UIColor(red: 140.0/255.0, green: 136.0/255.0, blue: 119.0/255.0, alpha: 1.0)
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
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        addTapGestureOnScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didTextChange() {
        planPlaceholderLabel.isHidden = !planTextView.text.isEmpty
    }
    
    @objc
    private func touchesScrollView() {
        planTextView.resignFirstResponder()
    }
    
    // MARK: Methods
    func updateTextViewPosition(bottomButtonHeight: CGFloat) {
        guard planTextView.isFirstResponder else { return }
        let labelPostion = scrollView.frame.height - ruleDescriptionLabel.frame.maxY
        let y = (bottomButtonHeight > labelPostion) ? bottomButtonHeight - labelPostion + 5.0 : 0
        let offset = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(offset, animated: true)
        
    }
    
    // MARK: Helpers
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }
    
    private func configure() {
        self.backgroundColor = .white
        ruleDescriptionLabel.text = "Enter at least 14 characters"
        NotificationCenter.default.addObserver(self, selector: #selector(didTextChange), name: UITextView.textDidChangeNotification, object: nil)
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
//            $0.height.equalTo(1000.0)
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
            $0.height.equalTo(140.0)
        }

        planTextView.addSubview(planPlaceholderLabel)
        planPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(6.0)
            $0.trailing.equalToSuperview()
        }
        
        contentView.addSubview(ruleDescriptionLabel)
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(planBackgroundView.snp.bottom)
            $0.leading.equalTo(planBackgroundView)
        }
    }
}

extension HangoutPlanView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("DEBUG: didChange")
        ruleDescriptionLabel.isHidden = (textView.text.count >= 14)
        print("DEBUG: isHidden \(ruleDescriptionLabel.isHidden)")
    }
}
