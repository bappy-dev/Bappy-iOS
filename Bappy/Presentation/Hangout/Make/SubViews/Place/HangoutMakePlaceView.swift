//
//  HangoutMakePlaceView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakePlaceView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakePlaceViewModel
    private let disposeBag = DisposeBag()
    
    private let placeCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Write the place\nto meet"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let placeTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "place"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the place",
            attributes: [.foregroundColor: UIColor.bappyGray,
                         .font: UIFont.roboto(size: 16.0)])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 18.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = .rgb(241, 209, 83, 1)
        return underlinedView
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakePlaceViewModel) {
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
        self.addSubview(placeCaptionLabel)
        placeCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeCaptionLabel.snp.bottom).offset(96.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }
        
        self.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(placeTextField.snp.bottom).offset(7.0)
        }
    }
}

// MARK: - Bind
extension HangoutMakePlaceView {
    private func bind() {
        placeTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.endEditing
            .emit(to: placeTextField.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.text
            .emit(to: placeTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
