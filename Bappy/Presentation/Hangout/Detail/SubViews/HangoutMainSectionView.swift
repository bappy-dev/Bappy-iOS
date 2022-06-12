//
//  HangoutMainSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit

protocol HangoutMainSectionViewDelegate: AnyObject {
    func didTapReportButton()
}
 
final class HangoutMainSectionView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutMainSectionViewDelegate?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 32.0, family: .Bold)
        textField.textColor = UIColor(named: "bappy_brown")
        return textField
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_date")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 20.0, family: .Medium)
        textField.textColor = UIColor(named: "bappy_brown")
        return textField
    }()
    
    private let languageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_language")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let languageTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 20.0, family: .Medium)
        textField.textColor = UIColor(named: "bappy_brown")
        return textField
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 20.0, family: .Medium)
        textField.textColor = UIColor(named: "bappy_brown")
        return textField
    }()
    
    private let openchatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_url")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var openchatButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "detail_arrow")
        button.setImage(image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = UIColor(named: "bappy_brown")
        button.setAttributedTitle(
            NSAttributedString(
                string: "Go Openchat   ",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 20.0, family: .Medium),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]),
            for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(openOpenchatURL), for: .touchUpInside)
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
    private func openOpenchatURL() {
        if let url = URL(string: "https://open.kakao.com/o/gyeerYje") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc
    private func didTapReportButton() {
        delegate?.didTapReportButton()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        titleTextField.text = "Who wants to go eat?"
        timeTextField.text = "03. Mar. 19:00"
        languageTextField.text = "English"
        placeTextField.text = "PNU maingate"
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [
            timeImageView, languageImageView, placeImageView, openchatImageView
        ])
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.contentMode = .scaleAspectFit
        vStackView.spacing = 23.0

        self.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.0)
            $0.leading.equalToSuperview().inset(25.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(17.0)
        }

        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(21.0)
            $0.leading.equalTo(titleTextField)
            $0.width.equalTo(20.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }

        self.addSubview(timeTextField)
        timeTextField.snp.makeConstraints {
            $0.centerY.equalTo(timeImageView)
            $0.leading.equalTo(vStackView.snp.trailing).offset(14.0)
        }

        self.addSubview(languageTextField)
        languageTextField.snp.makeConstraints {
            $0.centerY.equalTo(languageImageView)
            $0.leading.equalTo(timeTextField)
        }

        self.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.centerY.equalTo(placeImageView)
            $0.leading.equalTo(languageTextField)
        }

        self.addSubview(openchatButton)
        openchatButton.snp.makeConstraints {
            $0.centerY.equalTo(openchatImageView)
            $0.leading.equalTo(placeTextField)
        }
    }
}
