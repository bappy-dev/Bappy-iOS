//
//  HangoutMainSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast

final class HangoutMainSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMainSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 32.0, family: .Bold)
        label.textColor = .bappyBrown
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_date")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let languageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_language")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.textColor = .bappyBrown
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let openchatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_url")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let openchatButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "detail_arrow")
        let seletedImage = UIImage(systemName: "list.clipboard")
        
        button.setImage(image, for: .normal)
        button.setImage(seletedImage, for: .selected)
        button.semanticContentAttribute = .forceRightToLeft
        button.setBappyTitle(
            title: "Go To URL   ",
            font: .roboto(size: 20.0, family: .Medium),
            hasUnderline: true
        )
        
        button.setBappyTitle(
            title: "Copy The Message   ",
            font: .roboto(size: 20.0, family: .Medium),
            hasUnderline: true,
            isSelected: true
        )
        button.isHidden = true
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    
    // MARK: Lifecycle
    init(viewModel: HangoutMainSectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [
            timeImageView, languageImageView, placeImageView, openchatImageView
        ])
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.contentMode = .scaleAspectFit
        vStackView.spacing = 23.0
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.0)
            $0.leading.equalToSuperview().inset(25.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(17.0)
        }
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21.0)
            $0.leading.equalTo(titleLabel)
            $0.width.equalTo(20.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeImageView)
            $0.leading.equalTo(vStackView.snp.trailing).offset(14.0)
        }
        
        self.addSubview(languageLabel)
        languageLabel.snp.makeConstraints {
            $0.centerY.equalTo(languageImageView)
            $0.leading.equalTo(timeLabel)
        }
        
        self.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.centerY.equalTo(placeImageView)
            $0.leading.equalTo(languageLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
        
        self.addSubview(openchatButton)
        openchatButton.snp.makeConstraints {
            $0.centerY.equalTo(openchatImageView)
            $0.leading.equalTo(placeLabel)
        }
    }
}

// MARK: - Bind
extension HangoutMainSectionView {
    private func bind() {
        openchatButton.rx.tap
            .bind(to: viewModel.input.openchatButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.title
            .emit(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.meetTime
            .emit(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.language
            .emit(to: languageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.placeName
            .emit(to: placeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideOpenchat
            .drive { [weak self] in
                self?.openchatImageView.isHidden = $0
                self?.openchatButton.isHidden = $0
            }.disposed(by: disposeBag)
        
        viewModel.output.isSelected
            .emit(to: openchatButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.goOpenchat
            .emit { [weak self] urlStr in
                EventLogger.logEvent("click", parameters: ["type": self?.openchatButton.isSelected ?? true ? "copy" : "openURL",
                                                           "component": "button",
                                                           "button": "openchat",
                                                           "name": "HangoutMainSectionView"])
                if self?.openchatButton.isSelected ?? true {
                    self?.superview?.superview?.superview?.makeToast("The Message is Copied", position: .bottom, title: nil, image: nil, completion: nil)
                    UIPasteboard.general.string = urlStr
                } else {
                    if let url = URL(string: urlStr) {
                        UIApplication.shared.open(url)
                    } else {
                        self?.superview?.superview?.superview?.makeToast("Fail to Open URL")
                    }
                }
            }.disposed(by: disposeBag)
    }
}
