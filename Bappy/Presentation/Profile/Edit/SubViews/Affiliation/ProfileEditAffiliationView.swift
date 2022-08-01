//
//  ProfileEditAffiliationView.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileEditAffiliationView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileEditAffiliationViewModel
    private let disposeBag = DisposeBag()
    
    private let affiliationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_affiliation")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "University/Company"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let affiliationTextView: UITextView = {
        let textView = UITextView()
        textView.font = .roboto(size: 12.0, family: .Regular)
        textView.textColor = .bappyBrown
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0)
        label.textColor = .bappyGray
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: ProfileEditAffiliationViewModel) {
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
        backgroundView.backgroundColor = .bappyLightgray
        backgroundView.layer.cornerRadius = 11.0
    }
    
    private func layout() {
        self.addSubview(affiliationImageView)
        affiliationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(66.0)
            $0.width.equalTo(23.0)
            $0.height.equalTo(14.0)
        }
        
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(affiliationImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(affiliationImageView)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(affiliationImageView.snp.bottom).offset(9.0)
            $0.leading.equalToSuperview().inset(59.0)
            $0.trailing.equalToSuperview().inset(58.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        backgroundView.addSubview(affiliationTextView)
        affiliationTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
        
        affiliationTextView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileEditAffiliationView {
    private func bind() {
        affiliationTextView.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        viewModel.output.placeHolder
            .drive(placeHolderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHidePlaceHolder
            .drive(placeHolderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.modifiedText
            .emit(to: affiliationTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
