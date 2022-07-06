//
//  ProfileDetailViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileDetailViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: ProfileDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .bappyBrown
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profile_edit"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView: ProfileDetailMainView
    private let introduceView: ProfileDetailIntroduceView
    private let affiliationView: ProfileDetailAffiliationView
    private let languageView: ProfileDetailLanguageView
    private let personalityView: ProfileDetailPersonalityView
    private let interestsView: ProfileDetailInterestsView
    
    // MARK: Lifecycle
    init(viewModel: ProfileDetailViewModel) {
        let mainViewModel = viewModel.subViewModels.mainViewModel
        let introduceViewModel = viewModel.subViewModels.introduceViewModel
        let affiliationViewModel = viewModel.subViewModels.affiliationViewModel
        let languageViewModel = viewModel.subViewModels.languageViewModel
        let personalityViewModel = viewModel.subViewModels.personalityViewModel
        let interestsViewModel = viewModel.subViewModels.interestsViewModel
        self.mainView = ProfileDetailMainView(viewModel: mainViewModel)
        self.introduceView = ProfileDetailIntroduceView(viewModel: introduceViewModel)
        self.affiliationView = ProfileDetailAffiliationView(viewModel: affiliationViewModel)
        self.languageView = ProfileDetailLanguageView(viewModel: languageViewModel)
        self.personalityView = ProfileDetailPersonalityView(viewModel: personalityViewModel)
        self.interestsView = ProfileDetailInterestsView(viewModel: interestsViewModel)
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(9.0)
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.height.equalTo(44.0)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(65.0)
            $0.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(31.0)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(10.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(introduceView)
        introduceView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(affiliationView)
        affiliationView.snp.makeConstraints {
            $0.top.equalTo(introduceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(languageView)
        languageView.snp.makeConstraints {
            $0.top.equalTo(affiliationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(personalityView)
        personalityView.snp.makeConstraints {
            $0.top.equalTo(languageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(interestsView)
        interestsView.snp.makeConstraints {
            $0.top.equalTo(personalityView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileDetailViewController {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind(to: viewModel.input.editButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hideEditButton
            .emit(to: editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.showEditView
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] viewModel in
                let viewController = ProfileEditViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
