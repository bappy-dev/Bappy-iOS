//
//  HangoutMakeViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/27.
//

import UIKit
import SnapKit
import YPImagePicker
import RxSwift
import RxCocoa

final class HangoutMakeViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: HangoutMakeViewModel
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton()
    private let progressBarView = ProgressBarView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let categoryView: HangoutMakeCategoryView
    private let titleView: HangoutMakeTitleView
    private let timeView: HangoutMakeTimeView
    private let placeView: HangoutMakePlaceView
    private let pictureView: HangoutMakePictureView
    private let planView: HangoutMakePlanView
    private let languageView: HangoutMakeLanguageView
    private let openchatView: HangoutMakeOpenchatView
    private let limitView: HangoutMakeLimitView
    private let continueButtonView: ContinueButtonView

    // MARK: Lifecycle
    init(viewModel: HangoutMakeViewModel) {
        let categoryViewModel = viewModel.subViewModels.categoryViewModel
        let titleViewModel = viewModel.subViewModels.titleViewModel
        let timeViewModel = viewModel.subViewModels.timeViewModel
        let placeViewModel = viewModel.subViewModels.placeViewModel
        let pictureViewModel = viewModel.subViewModels.pictureViewModel
        let planViewModel = viewModel.subViewModels.planViewModel
        let languageViewModel = viewModel.subViewModels.languageViewModel
        let openchatViewModel = viewModel.subViewModels.openchatViewModel
        let limitViewModel = viewModel.subViewModels.limitViewModel
        let continueButtonViewModel = viewModel.subViewModels.continueButtonViewModel
        
        self.viewModel = viewModel
        self.categoryView = HangoutMakeCategoryView(viewModel: categoryViewModel)
        self.titleView = HangoutMakeTitleView(viewModel: titleViewModel)
        self.timeView = HangoutMakeTimeView(viewModel: timeViewModel)
        self.placeView = HangoutMakePlaceView(viewModel: placeViewModel)
        self.pictureView = HangoutMakePictureView(viewModel: pictureViewModel)
        self.planView = HangoutMakePlanView(viewModel: planViewModel)
        self.languageView = HangoutMakeLanguageView(viewModel: languageViewModel)
        self.openchatView = HangoutMakeOpenchatView(viewModel: openchatViewModel)
        self.limitView = HangoutMakeLimitView(viewModel: limitViewModel)
        self.continueButtonView = ContinueButtonView(viewModel: continueButtonViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
        addTapGestureOnScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }

    @objc
    private func touchesScrollView() {
        view.endEditing(true)
    }

    // MARK: Helpers
    private func updateButtonPostion(keyboardHeight: CGFloat) {
        let bottomPadding = (keyboardHeight != 0) ? view.safeAreaInsets.bottom : view.safeAreaInsets.bottom * 2.0 / 3.0

        UIView.animate(withDuration: 0.4) {
            self.continueButtonView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomPadding - keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }
    
    private func configureImagePicker() -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.colors.tintColor = .bappyYellow
        config.shouldSaveNewPicturesToAlbum = false
        config.showsPhotoFilters = false
        config.showsCrop = .rectangle(ratio: 390.0/333.0)
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
        backButton.setImage(UIImage(named: "chevron_back"), for: .normal)
        backButton.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(5.5)
            $0.width.height.equalTo(44.0)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
        }
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(categoryView.snp.trailing)
        }

        view.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(titleView.snp.trailing)
        }
        
        view.addSubview(placeView)
        placeView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(timeView.snp.trailing)
        }
        
        view.addSubview(pictureView)
        pictureView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(placeView.snp.trailing)
        }
        
        view.addSubview(planView)
        planView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(pictureView.snp.trailing)
        }
        
        view.addSubview(languageView)
        languageView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(planView.snp.trailing)
        }
        
        view.addSubview(openchatView)
        openchatView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(languageView.snp.trailing)
        }
        
        view.addSubview(limitView)
        limitView.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(openchatView.snp.trailing)
        }
        
        view.addSubview(continueButtonView)
        continueButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(bottomPadding * 2.0 / 3.0)
        }
    }
}

// MARK: - Bind
extension HangoutMakeViewController {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        self.rx.viewDidAppear
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldKeyboardHide
            .emit(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.page
            .map(CGFloat.init)
            .map { CGPoint(x: UIScreen.main.bounds.width * $0, y: 0) }
            .drive(scrollView.rx.setContentOffset)
            .disposed(by: disposeBag)

        viewModel.output.progression
            .skip(1)
            .drive(progressBarView.rx.setProgression)
            .disposed(by: disposeBag)
        
        viewModel.output.initProgression
            .emit(to: progressBarView.rx.initProgression)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSearchPlaceView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = SearchPlaceViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overCurrentContext
                self?.present(viewController, animated: false, completion: nil)
            })
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
                            let edittedImage = photo.modifiedImage?.downSize(newWidth: 1000)
                            self.viewModel.input.picture.onNext(edittedImage)
                        }
                        picker.dismiss(animated: true)
                    }
                    .disposed(by: self.disposeBag)
                    
                self.present(picker, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSelectLanguageView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = SelectLanguageViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overCurrentContext
                self?.present(viewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.showTranslucentLoader)
            .disposed(by: disposeBag)
        
        viewModel.output.showHangoutPreview
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HangoutDetailViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                self?.updateButtonPostion(keyboardHeight: height)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .map { [weak self] height in
                return height + (self?.continueButtonView.frame.height ?? 0)
            }
            .drive(viewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
    }
}

