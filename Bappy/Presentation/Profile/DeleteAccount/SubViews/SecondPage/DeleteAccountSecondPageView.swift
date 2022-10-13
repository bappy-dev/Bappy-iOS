//
//  DeleteAccountSecondPageView.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DeleteAccountSecondPageView: UIView {
    
    // MARK: Properties
    private let viewModel: DeleteAccountSecondPageViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 24.0, family: .Medium)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let reasonBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .bappyLightgray
        backgroundView.layer.cornerRadius = 16.0
        return backgroundView
    }()
    
    private let reasonTextField: UITextField = {
        let textField = UITextField()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .rgb(177, 172, 154, 1)
        textField.font = .roboto(size: 12.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Select the reason for reporting.",
            attributes: [.foregroundColor: UIColor.rgb(169, 162, 139, 1)])
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 20.0)
        label.numberOfLines = 2
        label.textAlignment = .justified
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_sad")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dropdownView: BappyDropdownView
    
    // MARK: Lifecycle
    init(viewModel: DeleteAccountSecondPageViewModel) {
        let dropdownViewModel = viewModel.subViewModels.dropdownViewModel
        self.viewModel = viewModel
        self.dropdownView = BappyDropdownView(viewModel: dropdownViewModel)
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func openDropdown() {
        UIView.animate(withDuration: 0.3) {
            self.dropdownView.snp.updateConstraints {
                $0.height.equalTo(315.0)
            }
            self.layoutIfNeeded()
        }
    }
    
    func closeDropdown() {
        UIView.animate(withDuration: 0.3) {
            self.dropdownView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func configure() {
        self.backgroundColor = .white
        titleLabel.text = "Why do you leave BAPPY?"
        descriptionLabel.text = "If you want to leave, please tell us\nthe reason. Click the bar above!"
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36.0)
            $0.leading.trailing.equalToSuperview().inset(55.0)
        }
        
        self.addSubview(reasonBackgroundView)
        reasonBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            $0.leading.equalToSuperview().inset(40.0)
            $0.trailing.equalToSuperview().inset(32.0)
            $0.height.equalTo(32.0)
        }
        
        reasonBackgroundView.addSubview(reasonTextField)
        reasonTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.top.bottom.equalToSuperview()
        }
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(reasonBackgroundView.snp.bottom).offset(70.0)
            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(45.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40.0)
            $0.leading.trailing.equalToSuperview().inset(45.0)
            $0.height.equalTo(bappyImageView.snp.width).multipliedBy(148.0/291.0)
        }
        
        self.addSubview(dropdownView)
        dropdownView.snp.makeConstraints {
            $0.top.equalTo(reasonBackgroundView.snp.bottom).offset(5.0)
            $0.leading.trailing.equalTo(reasonBackgroundView)
            $0.height.equalTo(0)
        }
    }
}

// MARK: - Bind
extension DeleteAccountSecondPageView {
    private func bind() {
        reasonTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: reasonTextField.rx.endEditing)
            .disposed(by: disposeBag)
        
        reasonTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposeBag)
        
        viewModel.output.openDropdown
            .emit(onNext: { [weak self] _ in self?.openDropdown() })
            .disposed(by: disposeBag)
        
        viewModel.output.closeDropdown
            .emit(onNext: { [weak self] _ in self?.closeDropdown() })
            .disposed(by: disposeBag)
        
        viewModel.output.text
            .emit(to: reasonTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

