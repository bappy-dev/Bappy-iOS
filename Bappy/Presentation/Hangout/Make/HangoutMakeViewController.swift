//
//  HangoutMakeViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/27.
//

import UIKit
import SnapKit
import PhotosUI

final class HangoutMakeViewController: UIViewController {
    
    // MARK: Properties
    private var selectedImages = [UIImage]() {
        didSet {
            pictureView.selectedImages = self.selectedImages
        }
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
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

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

        progressBarView.initializeProgression(1.0/8.0)
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
        print("DEBUG: keyboardHeight \(keyboardHeight)")
        let bottomPadding = (keyboardHeight != 0) ? view.safeAreaInsets.bottom : view.safeAreaInsets.bottom * 2.0 / 3.0

        UIView.animate(withDuration: 0.4) {
            self.continueButtonView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomPadding - keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
        
        let bottomButtonHeight = keyboardHeight + continueButtonView.frame.height
        titleView.updateTextFieldPosition(bottomButtonHeight: bottomButtonHeight)
    }
    
    @objc
    private func backButtonHandler() {
        view.endEditing(true)
        guard page > 0 else {
            self.dismiss(animated: true)
            return
        }
        page -= 1
        continueButtonView.isEnabled = true
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
        continueButtonView.isEnabled = valid
    }
}

// MARK: - HangoutMakeTimeViewDelegate
extension HangoutMakeViewController: HangoutMakeTimeViewDelegate {
    func isTimeValid(_ valid: Bool) {
        continueButtonView.isEnabled = valid
    }
}


// MARK: - HangoutPlaceViewDelegate
extension HangoutMakeViewController: HangoutPlaceViewDelegate {
    func showSearchPlaceView() {
        view.endEditing(true) // 임시
        let viewController = SearchPlaceViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: - HangoutPictureViewDelegate
extension HangoutMakeViewController: HangoutPictureViewDelegate {
    func addPhoto() {
        guard numberOfImages < 9 else {
//            let popUpContents = "사진은 최대 9장까지 첨부할 수 있습니다."
//            let popUpViewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
//            popUpViewController.modalPresentationStyle = .overCurrentContext
//            present(popUpViewController, animated: false)
            return
        }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 9 - numberOfImages
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func removePhoto(indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.item - 1)
        numberOfImages -= 1
    }
}

// MARK: - HangoutLanguageViewDelegate
extension HangoutMakeViewController: HangoutLanguageViewDelegate {
    func showSelectLanguageView() {
        view.endEditing(true) // 임시
        let viewController = SelectLanguageViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: - ContinueButtonViewDelegate
extension HangoutMakeViewController: ContinueButtonViewDelegate {
    func continueButtonTapped() {
        view.endEditing(true)
        page += 1
        continueButtonView.isEnabled = false
    }
}

// MARK: - PHPickerViewControllerDelegate
extension HangoutMakeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }
        self.numberOfImages += results.count
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self, let image = object as? UIImage else { return }
                self.selectedImages.append(image.downSize(newWidth: 300))
            }
        }
    }
}


