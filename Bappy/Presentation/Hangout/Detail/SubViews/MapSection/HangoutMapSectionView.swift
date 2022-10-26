//
//  HangoutMapSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class HangoutMapSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMapSectionViewModel
    private let disposeBag = DisposeBag()

    private let mapButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14.0
        button.clipsToBounds = true
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0, family: .Bold)
        label.textColor = .bappyBrown
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMapSectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    // MARK: Helpers
    private func configureShadow() {
        backgroundView.addBappyShadow(shadowOffsetHeight: 1.0)
    }
    
    private func configure() {
        self.backgroundColor = .white
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 15.0
    }
    
    private func layout() {
        self.addSubview(mapButton)
        mapButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10.0)
            $0.leading.trailing.equalToSuperview().inset(27.0)
            $0.height.equalTo(mapButton.snp.width).multipliedBy(142.0/336.0)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-26.0)
            $0.centerX.equalToSuperview()
        }
        
        backgroundView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension HangoutMapSectionView {
    private func bind() {
        mapButton.rx.tap
            .bind(to: viewModel.input.mapButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.placeName
            .drive(placeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.mapImage
            .emit(to: mapButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
    }
}
 
