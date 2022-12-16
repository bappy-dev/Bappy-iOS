//
//  ProfileDetailInterestsView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileDetailInterestsView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileDetailInterestsViewModel
    private let disposeBag = DisposeBag()
    
    private let interestsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_interests")
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Interests"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0, family: .Bold)
        return label
    }()
    
    private let categoryView: CategoryView
    
    // MARK: Lifecycle
    init(viewModel: ProfileDetailInterestsViewModel) {
        let categoryViewModel = viewModel.subViewModels.categoryViewModel
        self.categoryView = CategoryView(viewModel: categoryViewModel)
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubviews([interestsImageView, captionLabel, categoryView])
        interestsImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19.0)
            $0.leading.equalToSuperview().inset(66.0)
            $0.width.equalTo(19.0)
            $0.height.equalTo(18.0)
        }
        
        captionLabel.snp.makeConstraints {
            $0.leading.equalTo(interestsImageView.snp.trailing).offset(6.0)
            $0.centerY.equalTo(interestsImageView)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(interestsImageView.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(44.0)
            $0.trailing.equalToSuperview().inset(44.0)
            $0.bottom.equalToSuperview().inset(55.0)
        }
    }
}
