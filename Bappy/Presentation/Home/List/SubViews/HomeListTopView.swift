//
//  HomeListTopView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

protocol HomeListTopViewDelegate: AnyObject {
    func localeButtonTapped()
    func searchButtonTapped()
    func filterButtonTapped()
}

final class HomeListTopView: UIView {
    
    // MARK: Properties
    weak var delegate: HomeListTopViewDelegate?
    
    private let logoImageView = UIImageView()
    private let localeButton = UIButton()
    private let searchButton = UIButton()
    private let filterButton = UIButton()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func localeButtonHandler() {
        delegate?.localeButtonTapped()
    }
    
    @objc
    private func searchButtonHandler() {
        delegate?.searchButtonTapped()
    }
    
    @objc
    private func filterButtonHandler() {
        delegate?.filterButtonTapped()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        logoImageView.image = UIImage(named:"home_logo")
        localeButton.setImage(UIImage(named: "home_location"), for: .normal)
        searchButton.setImage(UIImage(named: "home_search"), for: .normal)
        filterButton.setImage(UIImage(named: "home_filter"), for: .normal)
        localeButton.addTarget(self, action: #selector(localeButtonHandler), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonHandler), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonHandler), for: .touchUpInside)
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
        
        self.addSubview(filterButton)
        filterButton.snp.makeConstraints {
            $0.centerY.equalTo(localeButton)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.width.equalTo(40.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(localeButton)
            $0.trailing.equalTo(filterButton.snp.leading)
            $0.width.equalTo(40.0)
            $0.height.equalTo(44.0)
        }
    }
}
