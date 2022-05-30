//
//  ReportViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit
import PhotosUI

final class ReportViewController: UIViewController {
    
    // MARK: Properties
    private var selectedImages = [UIImage]() {
        didSet {
            imageSectionView.selectedImages = self.selectedImages
        }
    }
    
    private var numberOfImages = 0
    
    private let titleTopView = TitleTopView(title: "Report", subTitle: "Detail page")
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let writingSectionView = ReportWritingSectionView()
    private let imageSectionView = ReportImageSectionView()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()

    private let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "bappy_yellow")
        button.setAttributedTitle(
            NSAttributedString(
                string: "REPORT",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 18.0, family: .Medium)
                ]),
            for: .normal)
        button.layer.cornerRadius = 11.5
        button.addBappyShadow()
        return button
    }()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setStatusBarStyle(statusBarStyle: .lightContent)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        setStatusBarStyle(statusBarStyle: .darkContent)
    }

    // MARK: Actions
    @objc
    private func backButtonHandler() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY
        self.scrollView.contentInset.bottom = keyboardHeight
    }
    
    @objc
    private func didTapScrollView() {
        view.endEditing(true)
    }

    // MARK: Helpers
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addTapGestureOnScrollView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        guard let navigationController = navigationController as? BappyNavigationViewController else { return }
        navigationController.statusBarStyle = statusBarStyle
    }

    private func configure() {
        view.backgroundColor = .white
//        scrollView.keyboardDismissMode = .interactive
        imageSectionView.delegate = self
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        contentView.addSubview(imageSectionView)
        imageSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150.0)
        }

        contentView.addSubview(writingSectionView)
        writingSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(imageSectionView.snp.top)
        }
        
        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints {
            $0.top.equalTo(imageSectionView.snp.bottom).offset(74.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(157.0)
            $0.height.equalTo(43.0)
            $0.bottom.equalToSuperview().inset(42.0)
        }

        view.addSubview(titleTopView)
        titleTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.top)
            $0.height.equalTo(141.0)
        }

        titleTopView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(7.3)
            $0.width.height.equalTo(44.0)
        }
    }
}

// MARK: PHPickerViewControllerDelegate
extension ReportViewController: PHPickerViewControllerDelegate {
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

// MARK: ReportImageSectionViewDelegate
extension ReportViewController: ReportImageSectionViewDelegate {
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
