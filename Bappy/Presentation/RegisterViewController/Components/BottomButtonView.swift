//
//  BottomButtonView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit

protocol BottomButtonViewDelegate: AnyObject {
    func didTapPreviousButton()
    func didTapNextButton()
}

final class BottomButtonView: UIView {
    
    // MARK: Properties
    weak var delegate: BottomButtonViewDelegate?
    
    private lazy var previousButton: UIButton = {
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
                ]),
            for: .normal)
        button.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
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
                ]),
            for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didTapPreviousButton() {
        delegate?.didTapPreviousButton()
    }
    
    @objc
    private func didTapNextButton() {
        delegate?.didTapNextButton()
    }
    
    // MARK: Helpers
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
