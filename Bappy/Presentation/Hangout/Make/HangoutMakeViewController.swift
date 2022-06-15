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
    
    private var initialized: Bool = false
    private var selectedImage: UIImage? {
        didSet { pictureView.selectedImage = self.selectedImage }
    }
    
    private var numberOfImages = 0
    
    private var page: Int = 0 {
        didSet {
            let x: CGFloat = UIScreen.main.bounds.width * CGFloat(page)
            let offset = CGPoint(x: x, y: 0)
            scrollView.setContentOffset(offset, animated: true)
            progressBarView.updateProgression(CGFloat(page + 1) / 8.0)
        }
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron_back"), for: .normal)
        button.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()

    private let progressBarView = ProgressBarView()
    private let continueButtonView = ContinueButtonView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleView = HangoutMakeTitleView()
    private let timeView = HangoutMakeTimeView()
    private let placeView = HangoutPlaceView()
    private let pictureView = HangoutPictureView()
    private let planView = HangoutPlanView()
    private let languageView = HangoutLanguageView()
    private let openchatView = HangoutOpenchatView()
    private let participantsLimitView = HangoutParticipantsLimitView()

    // MARK: Lifecycle
    init(viewModel: HangoutMakeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        addKeyboardObserver()
        addTapGestureOnScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !initialized {
            progressBarView.initializeProgression(1.0/8.0)
            initialized = true
        }
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

    // MARK: Actions
    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY
        let bottomPadding = (keyboardHeight != 0) ? view.safeAreaInsets.bottom : view.safeAreaInsets.bottom * 2.0 / 3.0

        UIView.animate(withDuration: 0.4) {
            self.continueButtonView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomPadding - keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
        
        let bottomButtonHeight = keyboardHeight + continueButtonView.frame.height
        titleView.updateTextFieldPosition(bottomButtonHeight: bottomButtonHeight)
        planView.updateTextViewPosition(bottomButtonHeight: bottomButtonHeight)
        openchatView.updateTextFieldPosition(bottomButtonHeight: bottomButtonHeight)
    }
    
    @objc
    private func backButtonHandler() {
        view.endEditing(true)
        guard page > 0 else {
            self.dismiss(animated: true)
            return
        }
        page -= 1
//        continueButtonView.isEnabled = true
    }

    // MARK: Helpers
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configure() {
        view.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        titleView.delegate = self
        timeView.delegate = self
        placeView.delegate = self
        pictureView.delegate = self
        languageView.delegate = self
        continueButtonView.delegate = self
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
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
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
        
        view.addSubview(participantsLimitView)
        participantsLimitView.snp.makeConstraints {
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

// MARK: - HangoutMakeTitleViewDelegate
extension HangoutMakeViewController: HangoutMakeTitleViewDelegate {
    func isTitleValid(_ valid: Bool) {
//        continueButtonView.isEnabled = valid
    }
}

// MARK: - HangoutMakeTimeViewDelegate
extension HangoutMakeViewController: HangoutMakeTimeViewDelegate {
    func isTimeValid(_ valid: Bool) {
//        continueButtonView.isEnabled = valid
    }
}


// MARK: - HangoutPlaceViewDelegate
extension HangoutMakeViewController: HangoutPlaceViewDelegate {
    func showSearchPlaceView() {
        view.endEditing(true) // 임시
        let viewController = SearchPlaceViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: - SearchPlaceViewControllerDelegate
extension HangoutMakeViewController: SearchPlaceViewControllerDelegate {
    func getSelectedMap(_ map: Map) {
        placeView.map = map
//        continueButtonView.isEnabled = true
    }
}

// MARK: - SearchPlaceViewControllerDelegate
extension HangoutMakeViewController: SelectLanguageViewControllerDelegate {
    func getSelectedLanguage(_ language: String) {
        languageView.language = language
//        continueButtonView.isEnabled = true
    }
}

// MARK: - HangoutPictureViewDelegate
extension HangoutMakeViewController: HangoutPictureViewDelegate {
    func addPhoto() {
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
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [weak self, unowned picker] items, cancelled in
            guard !cancelled else {
                picker.dismiss(animated: true)
                return
            }
            if let photo = items.singlePhoto {
                self?.selectedImage = photo.modifiedImage
            }
            picker.dismiss(animated: true)
        }
        present(picker, animated: true)
    }
}

// MARK: - HangoutLanguageViewDelegate
extension HangoutMakeViewController: HangoutLanguageViewDelegate {
    func showSelectLanguageView() {
        view.endEditing(true) // 임시
        let viewController = SelectLanguageViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: - ContinueButtonViewDelegate
extension HangoutMakeViewController: ContinueButtonViewDelegate {
    func continueButtonTapped() {
        view.endEditing(true)
        page += 1
//        continueButtonView.isEnabled = false / asdfasdffsd
    }
}
