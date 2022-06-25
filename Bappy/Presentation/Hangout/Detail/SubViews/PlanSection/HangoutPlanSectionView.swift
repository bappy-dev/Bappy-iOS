//
//  HangoutPlanSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutPlanSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutPlanSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let planImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_plan")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let planCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Medium)
        label.text = "Hangout Plan"
        label.textColor = .bappyBrown
        return label
    }()
    
    private let planTextView: UITextView = {
        let textView = UITextView()
        textView.font = .roboto(size: 15.0, family: .Light)
        textView.textColor = .bappyBrown
        textView.textAlignment = .justified
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    private let backgroundView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: HangoutPlanSectionViewModel) {
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
        backgroundView.layer.cornerRadius = 20.0
    }
    
    private func layout() {
        self.addSubview(planImageView)
        planImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.leading.equalToSuperview().inset(38.0)
            $0.width.equalTo(17.0)
            $0.height.equalTo(20.0)
        }
        
        self.addSubview(planCaptionLabel)
        planCaptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(planImageView)
            $0.leading.equalTo(planImageView.snp.trailing).offset(10.0)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(planCaptionLabel.snp.bottom).offset(8.0)
            $0.leading.equalToSuperview().inset(27.0)
            $0.trailing.equalToSuperview().inset(23.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        backgroundView.addSubview(planTextView)
        planTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(19.0)
            $0.trailing.equalToSuperview().inset(21.0)
        }
    }
}

// MARK: - Bind
extension HangoutPlanSectionView {
    private func bind() {
        viewModel.output.planText
            .emit(to: planTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
