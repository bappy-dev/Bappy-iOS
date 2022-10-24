//
//  MoveWithKeyboardView.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MoveWithKeyboardView: UIView {
    
    // MARK: Properties
    private let viewModel: MoveWithKeyboardViewModel
    private let disposeBag = DisposeBag()
    
    private let textField = BappyTextField()
    
    private let backButton = UIButton()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setBappyTitle(
            title: "Continue",
            font: .roboto(size: 23.0, family: .Bold)
        )
        button.layer.cornerRadius = 23.5
        return button
    }()
    
    // MARK: Lifecycle
    init(viewModel: MoveWithKeyboardViewModel) {
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
    func setText(_ text: String) {
        textField.text = text
    }
    
    private func configure() {
        self.backgroundColor = .white
        backButton.setImage(UIImage(named: "chevron_back")?.withTintColor(.bappyGray), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(
            top: 8.0,
            left: 8.0,
            bottom: 8.0,
            right: 16.0
        )
        backButton.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 8.0,
            bottom: 0,
            right: -8.0
        )
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(.bappyGray, for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.titleLabel?.font = .roboto(size: 14.0, family: .Medium)
        textField.placeholder = "Do you wanna leave a message?"
    }
    
    private func layout() {
        addSubview(textField)
        addSubview(backButton)
        addSubview(continueButton)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.leading.trailing.equalToSuperview().inset(23.0)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(continueButton)
            $0.leading.equalToSuperview().inset(30.0)
            $0.height.equalTo(44.0)
        }
        
        self.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().inset(30.0)
            make.bottom.equalToSuperview().inset(10.0)
            make.height.equalTo(47.0)
            make.width.equalTo(150.0)
        }
    }
}

// MARK: - Bind
extension MoveWithKeyboardView {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        textField.rx.value
            .compactMap { $0 }
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind(to: viewModel.input.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.continueButton.isEnabled = isEnabled
                self.continueButton.backgroundColor = isEnabled ? .bappyYellow : .rgb(238, 238, 234, 1)
            })
            .disposed(by: disposeBag)
    }
}
