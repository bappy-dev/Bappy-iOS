//
//  ProfileDetailMainView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class ProfileDetailMainView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileDetailMainViewModel
    private let disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 29.5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
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
    
    
    // MARK: Lifecycle
    init(viewModel: ProfileDetailMainViewModel) {
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
            $0.top.equalToSuperview().inset(5.0)
            $0.leading.equalToSuperview().inset(64.0)
            $0.width.height.equalTo(59.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20.0)
            $0.bottom.equalTo(profileImageView.snp.centerY)
        }
        
        self.addSubview(flagLabel)
        flagLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(3.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
        flagLabel.snp.contentCompressionResistanceHorizontalPriority = 751
        
        self.addSubview(genderAndBirthLabel)
        genderAndBirthLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(18.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
    }
}

// MARK: - Bind
extension ProfileDetailMainView {
    private func bind() {
        viewModel.output.profileImageURL
            .drive(onNext: { [weak self] url in
                let placeHolder = UIImage(named: "profile_default")
                self?.profileImageView.kf.setImage(with: url, placeholder: placeHolder)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.flag
            .drive(flagLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.genderAndBirth
            .drive(genderAndBirthLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
