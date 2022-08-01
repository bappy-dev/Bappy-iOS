//
//  ReportViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit
import PhotosUI
import RxSwift
import RxCocoa
import Kingfisher

final class ReportViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: ReportViewModel
    private let disposeBag = DisposeBag()

    private let titleTopView = TitleTopView(title: "Report", subTitle: "Detail page")
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let writingSectionView: ReportWritingSectionView
    private let imageSectionView: ReportImageSectionView

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    private let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .bappyYellow
        button.setBappyTitle(
            title: "REPORT",
            font: .roboto(size: 18.0, family: .Medium))
        button.layer.cornerRadius = 11.5
        button.addBappyShadow()
        return button
    }()

    // MARK: Lifecycle
    init(viewModel: ReportViewModel) {
        let writingViewModel = viewModel.subViewModels.writingViewModel
        let imageViewModel = viewModel.subViewModels.imageViewModel
        self.viewModel = viewModel
        self.writingSectionView = ReportWritingSectionView(viewModel: writingViewModel)
        self.imageSectionView = ReportImageSectionView(viewModel: imageViewModel)
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

        setStatusBarStyle(statusBarStyle: .lightContent)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        setStatusBarStyle(statusBarStyle: .darkContent)
    }

    // MARK: Actions
    @objc
    private func didTapScrollView() {
        view.endEditing(true)
    }

    // MARK: Helpers
    private func showPHPickerView(selectionLimit: Int) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = selectionLimit
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
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
        scrollView.keyboardDismissMode = .interactive
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
        }

        contentView.addSubview(writingSectionView)
        writingSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(imageSectionView.snp.top)
        }
        
        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints {
            $0.top.equalTo(imageSectionView.snp.bottom).offset(28.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(157.0)
            $0.height.equalTo(43.0)
            $0.bottom.equalToSuperview().inset(42.0)
        }

        view.addSubview(titleTopView)
        titleTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(94.0)
            $0.bottom.equalTo(scrollView.snp.top)
        }

        titleTopView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(7.3)
            $0.width.height.equalTo(44.0)
        }
    }
}

// MARK: - Bind
extension ReportViewController {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .bind(to: viewModel.input.reportButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showPHPickerView
            .compactMap { $0 }
            .emit(onNext: { [weak self] num in
                self?.showPHPickerView(selectionLimit: num)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSuccessView
            .emit(onNext: { [weak self] _ in
                let viewController = ReportSuccessViewController()
                viewController.modalPresentationStyle = .fullScreen
                viewController.setDismissCompletion {
                    self?.navigationController?.popViewController(animated: false)
                }
                self?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.scrollView.contentInset.bottom = height
                self?.scrollView.verticalScrollIndicatorInsets.bottom = height
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ReportViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self, let image = object as? UIImage else { return }
                self.viewModel.input.addedImage.onNext(image)
            }
        }
    }
}
