//
//  HangoutDetailViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutDetailViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: HangoutDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let titleTopView = TitleTopView(title: "Hangout", subTitle: "Detail page")
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageSectionView: HangoutImageSectionView
    private let mainSectionView: HangoutMainSectionView
    private let mapSectionView: HangoutMapSectionView
    private let planSectionView: HangoutPlanSectionView
    private let participantsSectionView: HangoutParticipantsSectionView
    
    private let hangoutButton = HangoutButton()
    
    private let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "detail_report"), for: .normal)
        button.setBappyTitle(
            title: "    I want to report this hangout",
            font: .roboto(size: 16.0, family: .Medium),
            hasUnderline: true)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutDetailViewModel) {
        let imageSectionViewModel = viewModel.subViewModels.imageSectionViewModel
        let mainSectionViewModel = viewModel.subViewModels.mainSectionViewModel
        let mapSectionViewModel = viewModel.subViewModels.mapSectionViewModel
        let planSectionViewModel = viewModel.subViewModels.planSectionViewModel
        let participantsSectionViewModel = viewModel.subViewModels.participantsSectionViewModel
        
        self.viewModel = viewModel
        self.imageSectionView = HangoutImageSectionView(viewModel: imageSectionViewModel)
        self.mainSectionView = HangoutMainSectionView(viewModel: mainSectionViewModel)
        self.mapSectionView = HangoutMapSectionView(viewModel: mapSectionViewModel)
        self.planSectionView = HangoutPlanSectionView(viewModel: planSectionViewModel)
        self.participantsSectionView = HangoutParticipantsSectionView(viewModel: participantsSectionViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
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
    
    // MARK: Helpers
    private func showSigninPopupView() {
        let popupView = SigninPopupViewController()
        popupView.modalPresentationStyle = .overCurrentContext
        present(popupView, animated: false)
    }
    
    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        guard let navigationController = navigationController as? BappyNavigationViewController else { return }
        navigationController.statusBarStyle = statusBarStyle
    }
    
    private func configure() {
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInsetAdjustmentBehavior = .never
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
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageSectionView.snp.width).multipliedBy(239.0/390.0)
        }
        
        contentView.addSubview(mainSectionView)
        mainSectionView.snp.makeConstraints {
            $0.top.equalTo(imageSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(mapSectionView)
        mapSectionView.snp.makeConstraints {
            $0.top.equalTo(mainSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(planSectionView)
        planSectionView.snp.makeConstraints {
            $0.top.equalTo(mapSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(participantsSectionView)
        participantsSectionView.snp.makeConstraints {
            $0.top.equalTo(planSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(hangoutButton)
        hangoutButton.snp.makeConstraints {
            $0.top.equalTo(participantsSectionView.snp.bottom).offset(33.0)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints {
            $0.top.equalTo(hangoutButton.snp.bottom).offset(18.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(90.0)
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
extension HangoutDetailViewController {
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        hangoutButton.rx.tap
            .bind(to: viewModel.input.hangoutButtonTapped)
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .bind(to: viewModel.input.reportButtonTapped)
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .withLatestFrom(scrollView.rx.contentOffset)
            .map { $0.y }
            .filter { $0 <= 0 }
            .map { self.imageSectionView.frame.height - $0 }
            .bind(to: viewModel.input.imageHeight)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showOpenMapView
            .emit(onNext: { [weak self] viewModel in
                let popupView = OpenMapPopupViewController(viewModel: viewModel)
                popupView.modalPresentationStyle = .overCurrentContext
                self?.present(popupView, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hangoutButtonState
            .emit(to: hangoutButton.rx.hangoutState)
            .disposed(by: disposeBag)
        
        viewModel.output.showSigninPopupView
            .emit(onNext: { [weak self] _ in
                self?.showSigninPopupView()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showReportView
            .emit(onNext: { [weak self] _ in
                let viewController = ReportViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
