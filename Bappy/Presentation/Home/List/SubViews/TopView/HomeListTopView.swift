//
//  HomeListTopView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeListTopView: UIView {
    
    // MARK: Properties
    private let viewModel: HomeListTopViewModel
    private let disposeBag = DisposeBag()
    
    private let logoImageView = UIImageView()
    private let localeButton = UIButton()
    private let searchButton = UIButton()
    private let filterButton = UIButton()
    
    // MARK: Lifecycle
    init(viewModel: HomeListTopViewModel) {
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
        logoImageView.image = UIImage(named:"home_logo")
        localeButton.setImage(UIImage(named: "home_location"), for: .normal)
        searchButton.setImage(UIImage(named: "home_search"), for: .normal)
        filterButton.setImage(UIImage(named: "home_filter"), for: .normal)
        filterButton.isHidden = true
    }
    
    private func layout() {
        self.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.width.equalTo(110.0)
            $0.height.equalTo(43.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        self.addSubview(localeButton)
        localeButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView)
            $0.leading.equalToSuperview().inset(12.0)
            $0.width.height.equalTo(44.0)
        }
        
//        self.addSubview(filterButton)
//        filterButton.snp.makeConstraints {
//            $0.centerY.equalTo(localeButton)
//            $0.trailing.equalToSuperview().inset(8.0)
//            $0.width.height.equalTo(44.0)
//        }
        
        self.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(localeButton)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.height.equalTo(44.0)
        }
    }
}

// MARK: - Bind
extension HomeListTopView {
    private func bind() {
        localeButton.rx.tap
            .bind(to: viewModel.input.localeButtonTapped)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.input.searchButtonTapped)
            .disposed(by: disposeBag)
        
        filterButton.rx.tap
            .bind(to: viewModel.input.filterButtonTapped)
            .disposed(by: disposeBag)
    }
}
