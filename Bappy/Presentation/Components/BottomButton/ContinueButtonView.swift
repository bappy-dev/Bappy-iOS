//
//  ContinueButtonView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ContinueButtonView: UIView {
    
    // MARK: Properties
    private let viewModel: ContinueButtonViewModel
    private let disposeBag = DisposeBag()
    
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
    init(viewModel: ContinueButtonViewModel) {
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
        self.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(48.0)
            $0.trailing.equalToSuperview().inset(47.0)
            $0.bottom.equalToSuperview().inset(28.0)
            $0.height.equalTo(47.0)
        }
    }
}

// MARK: - Bind
extension ContinueButtonView {
    private func bind() {
        continueButton.rx.tap
            .bind(to: viewModel.input.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.continueButton.isEnabled = isEnabled
                self.continueButton.backgroundColor = isEnabled ? .bappyYellow : UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            })
            .disposed(by: disposeBag)
    }
}
