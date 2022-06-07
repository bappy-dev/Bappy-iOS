//
//  ContinueButtonView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/07.
//

import UIKit
import SnapKit

protocol ContinueButtonViewDelegate: AnyObject {
    func continueButtonTapped()
}

final class ContinueButtonView: UIView {
    
    // MARK: Properties
    weak var delegate: ContinueButtonViewDelegate?
    
    var isEnabled: Bool = false {
        didSet {
            continueButton.isEnabled = isEnabled
            continueButton.backgroundColor = isEnabled ? UIColor(named: "bappy_yellow") : UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
    }
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Continue",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 23.0, family: .Bold)
                ]), for: .normal)
        button.layer.cornerRadius = 23.5
        button.addTarget(self, action: #selector(continueButtonHandler), for: .touchUpInside)
        return button
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
    
    // MARK: Actions
    @objc
    private func continueButtonHandler(_ button: UIButton) {
        delegate?.continueButtonTapped()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        isEnabled = false
    }
    
    private func layout() {
        self.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(48.0)
            $0.trailing.equalToSuperview().inset(47.0)
            $0.bottom.equalToSuperview().inset(28.0)
            $0.height.equalTo(47.0)
        }
    }
}
