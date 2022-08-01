//
//  ProfileEditViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/20.
//

import UIKit
import SnapKit
import YPImagePicker
import RxSwift
import RxCocoa

final class ProfileEditViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: ProfileEditViewModel
    private let disposeBag = DisposeBag()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .bappyBrown
        return button
    }()
    
    private let saveButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView: ProfileEditMainView
    private let introduceView: ProfileEditIntroduceView
    private let affiliationView: ProfileEditAffiliationView
    private let languageView: ProfileEditLanguageView
    private let personalityView: ProfileEditPersonalityView
    private let interestsView: ProfileEditInterestsView
    
    // MARK: Lifecycle
    init(viewModel: ProfileEditViewModel) {
        let mainViewModel = viewModel.subViewModels.mainViewModel
        let introduceViewModel = viewModel.subViewModels.introduceViewModel
        let affiliationViewModel = viewModel.subViewModels.affiliationViewModel
        let languageViewModel = viewModel.subViewModels.languageViewModel
        let personalityViewModel = viewModel.subViewModels.personalityViewModel
        let interestsViewModel = viewModel.subViewModels.interestsViewModel
        self.mainView = ProfileEditMainView(viewModel: mainViewModel)
        self.introduceView = ProfileEditIntroduceView(viewModel: introduceViewModel)
        self.affiliationView = ProfileEditAffiliationView(viewModel: affiliationViewModel)
        self.languageView = ProfileEditLanguageView(viewModel: languageViewModel)
        self.personalityView = ProfileEditPersonalityView(viewModel: personalityViewModel)
        self.interestsView = ProfileEditInterestsView(viewModel: interestsViewModel)
        
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
    private func configureImagePicker() -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.colors.tintColor = .bappyYellow
        config.shouldSaveNewPicturesToAlbum = false
        config.showsPhotoFilters = false
        config.showsCrop = .rectangle(ratio: 1.0)
        config.showsCropGridOverlay = true
        config.library.mediaType = .photo
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        config.wordings.next = "Select"
        config.wordings.save = "Done"
        config.startOnScreen = .library
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.spacingBetweenItems = 2.0
        return YPImagePicker(configuration: config)
    }
    
    private func configure() {
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
        saveButton.setImage(UIImage(named: "profile_save"), for: .normal)
    }
    
    private func layout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(9.0)
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.height.equalTo(44.0)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
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
extension ProfileEditViewController {
    private func bind() {
        saveButton.rx.tap
            .bind(to: viewModel.input.saveButtonTapped)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hideEditButton
            .emit(to: saveButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.showImagePicker
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                let picker = self.configureImagePicker()
                picker.didFinishPicking
                    .subscribe { items, cancelled in
                        guard !cancelled else {
                            picker.dismiss(animated: true)
                            return
                        }
                        if let photo = items.singlePhoto {
                            self.viewModel.input.edittedImage.onNext(photo.modifiedImage)
                        }
                        picker.dismiss(animated: true)
                    }
                    .disposed(by: self.disposeBag)
                    
                self.present(picker, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLanguageView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                self?.view.endEditing(true)
                let viewController = ProfileLanguageViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overCurrentContext
                self?.present(viewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.switchToMainView
            .compactMap { $0 }
            .emit(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToMainView(viewModel: viewModel, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.showYellowLoader)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.scrollView.contentInset.bottom = height
                self?.scrollView.verticalScrollIndicatorInsets.bottom = height
            }).disposed(by: disposeBag)
    }
}
