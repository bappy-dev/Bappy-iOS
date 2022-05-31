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
        didSet { print("DEBUG: page \(page)") }
    }
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 24.0, family: .Medium)
        label.text = "Make Hangout"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()

    private let progressBarView = ProgressBarView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bottomButtonView = BottomButtonView(viewModel: BottomButtonViewModel())
    
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

        progressBarView.initializeProgression()
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
//        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        let keyboardHeight = view.frame.height - keyboardFrame.minY
//
//        UIView.animate(withDuration: 0.3) {
//            self.bottomButtonView.snp.updateConstraints {
//                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-1 * keyboardHeight)
//            }
//            self.view.layoutIfNeeded()
//        }
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
        scrollView.backgroundColor = .systemGray6
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true // 임시
//        scrollView.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        titleLabel.addBappyShadow(shadowOffsetHeight: 1.0)
        placeView.delegate = self
        pictureView.delegate = self
        languageView.delegate = self
    }

    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(25.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }

        contentView.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(titleView.snp.trailing)
        }
        
        contentView.addSubview(placeView)
        placeView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(timeView.snp.trailing)
        }
        
        contentView.addSubview(pictureView)
        pictureView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(placeView.snp.trailing)
        }
        
        contentView.addSubview(planView)
        planView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(pictureView.snp.trailing)
        }
        
        contentView.addSubview(languageView)
        languageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(planView.snp.trailing)
        }
        
        contentView.addSubview(openchatView)
        openchatView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(languageView.snp.trailing)
        }
        
        contentView.addSubview(participantsLimitView)
        participantsLimitView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(openchatView.snp.trailing)
        }
        
        view.addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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

// MARK: - Hangout
extension HangoutMakeViewController: HangoutLanguageViewDelegate {
    func showSelectLanguageView() {
        view.endEditing(true) // 임시
        let viewController = SelectLanguageViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
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
