//
//  ProfileHeaderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class ProfileHeaderView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileHeaderViewModel
    private let disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 45.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let flagLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let genderAndBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 16.0)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let profileButton: UIButton = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
//        btn.layer.cornerRadius = 45.5
//        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "profile_more"), for: .normal)
        return btn
    }()
    
    private let buttonSectionView: ProfileButtonSectionView
    
    // MARK: Lifecycle
    init(viewModel: ProfileHeaderViewModel) {
        let buttonSectionViewModel = viewModel.subViewModels.buttonSectionViewModel
        self.buttonSectionView = ProfileButtonSectionView(viewModel: buttonSectionViewModel)
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
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58.0)
            $0.width.height.equalTo(91.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(11.0)
            $0.centerX.equalToSuperview().offset(-6.0)
        }
        
        self.addSubview(flagLabel)
        flagLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(5.0)
        }
        
        self.addSubview(genderAndBirthLabel)
        genderAndBirthLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.centerY.equalTo(genderAndBirthLabel)
            $0.height.equalTo(33)
            $0.width.equalTo(65)
            $0.trailing.equalToSuperview().inset(34.0)
        }

        self.addSubview(buttonSectionView)
        buttonSectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileHeaderView {
    private func bind() {
        profileButton.rx.tap
            .bind(to: viewModel.input.moreButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.profileImageURL
            .emit(onNext: { [weak self] url in
                let placeHolder = UIImage(named: "no_profile_l")
                self?.profileImageView.kf.setImage(with: url, placeholder: placeHolder)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.name
            .compactMap { $0 }
            .emit(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.flag
            .compactMap { $0 }
            .emit(to: flagLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.genderAndBirth
            .compactMap { $0 }
            .emit(to: genderAndBirthLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
