//
//  HangoutMakeCategoryView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeCategoryView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeCategoryViewModel
    private let disposeBag = DisposeBag()
    
    private let categoryCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select your\nhangout category!"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let ruleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0)
        label.textColor = .bappyCoral
        label.text = "Select at least one category"
        return label
    }()
    
    private let categoryView: CategoryView
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakeCategoryViewModel) {
        let categoryViewModel = viewModel.subViewModels.categoryViewModel
        self.viewModel = viewModel
        self.categoryView = CategoryView(viewModel: categoryViewModel)
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
        self.addSubviews([categoryCaptionLabel, categoryView, ruleDescriptionLabel])
        categoryCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(43.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(50.0)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(categoryCaptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(39.0)
        }
        
        ruleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(10)
            $0.leading.equalTo(categoryView).offset(12.0)
            $0.centerX.equalToSuperview()
        }
    }
}

extension HangoutMakeCategoryView {
    private func bind() {
        viewModel.output.shouldHideRule
            .map { print("shouldHideRule",$0); return $0 }
            .drive(ruleDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
    }
}
