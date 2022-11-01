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
    private var participantsSectionView: HangoutParticipantsSectionView
    
    private let hangoutButton = HangoutButton()
    private let reviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Write Reviews!", for: .normal)
        btn.tintColor = .bappyBrown
        btn.setTitleColor(.bappyBrown, for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleLabel?.font = .roboto(size: 18, family: .Bold)
        btn.backgroundColor = .bappyYellow
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.layer.cornerRadius = 20.0
        btn.clipsToBounds = true
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing =  18
        view.addArrangedSubview(self.hangoutButton)
        view.addArrangedSubview(self.reviewButton)
        view.addArrangedSubview(self.reportButton)
        view.axis = .vertical
        return view
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrowshape.turn.up.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    private let emptyJoinedLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Let's join and wait!"
        lbl.font = .roboto(size: 20.0, family: .Medium)
        lbl.textAlignment = .center
        lbl.isHidden = true
        return lbl
    }()
    
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
    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        let navigationController = navigationController?.tabBarController?.navigationController as? BappyNavigationViewController
        navigationController?.statusBarStyle = statusBarStyle
    }
    
    private func configure() {
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func layout() {
        view.addSubviews([scrollView, titleTopView])
        scrollView.addSubview(contentView)
        titleTopView.addSubviews([backButton, shareButton])
        contentView.addSubviews([imageSectionView, mainSectionView, mapSectionView, planSectionView, participantsSectionView, stackView, emptyJoinedLbl])
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        imageSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageSectionView.snp.width).multipliedBy(239.0/390.0)
        }
        
        mainSectionView.snp.makeConstraints {
            $0.top.equalTo(imageSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        mapSectionView.snp.makeConstraints {
            $0.top.equalTo(mainSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        planSectionView.snp.makeConstraints {
            $0.top.equalTo(mapSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        participantsSectionView.snp.makeConstraints {
            $0.top.equalTo(planSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        emptyJoinedLbl.snp.makeConstraints {
            $0.centerX.equalTo(participantsSectionView.snp.centerX)
            $0.top.equalTo(participantsSectionView.snp.centerY)
        }
        
        reportButton.snp.makeConstraints {
            $0.width.equalTo(250.0)
            $0.height.equalTo(44.0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(participantsSectionView.snp.bottom).offset(33.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
            $0.bottom.equalToSuperview().inset(90.0)
            $0.height.greaterThanOrEqualTo(59).priority(.required)
            $0.height.lessThanOrEqualTo(121).priority(.high)
        }
        
        titleTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(94.0)
            $0.bottom.equalTo(scrollView.snp.top)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(7.3)
            $0.width.height.equalTo(44.0)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(7.3)
            $0.width.height.equalTo(50.0)
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
        
        reviewButton.rx.tap
            .bind(to: viewModel.input.reviewButtonTapped)
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .bind(to: viewModel.input.reportButtonTapped)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .bind {
                let activityVC = UIActivityViewController(activityItems: ["이 일정을 다른 사람과 공유하기"], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                
                // 공유하기 기능 중 제외할 기능이 있을 때 사용
                //        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .withLatestFrom(scrollView.rx.contentOffset)
            .map(\.y)
            .filter { $0 <= 0 }
            .map { [weak self] y -> CGFloat in
                let imageHeight = self?.imageSectionView.frame.height ?? 0
                return imageHeight - y }
            .bind(to: viewModel.input.imageHeight)
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showOpenMapView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let popupView = OpenMapPopupViewController(viewModel: viewModel)
                popupView.modalPresentationStyle = .overCurrentContext
                self?.present(popupView, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hangoutButtonState
            .emit(onNext: { [weak self] state in
                self?.emptyJoinedLbl.isHidden = state != .create
                self?.reportButton.isHidden = state == .create
                self?.hangoutButton.hangoutState = state
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSignInAlert
            .compactMap { $0 }
            .emit(to: self.rx.showSignInAlert)
            .disposed(by: disposeBag)
        
        viewModel.output.showCancelAlert
            .compactMap { $0 }
            .emit(to: self.rx.showAlert)
            .disposed(by: disposeBag)
        
        viewModel.output.showReportView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = ReportViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showUserProfile
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = ProfileViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showCreateSuccessView
            .emit(onNext: { [weak self] _ in
                let title = "Successfully Created!"
                let message = "Your hangout is succesfully created\nPlease check if your openchat is valid"
                let viewController = SuccessViewController(title: title, message: message)
                viewController.modalPresentationStyle = .fullScreen
                viewController.setDismissCompletion {
                    _ = self?.navigationController?.popToRootViewController(animated: false)
                }
                self?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showYellowLoader
            .emit(to: ProgressHUD.rx.showYellowLoader)
            .disposed(by: disposeBag)
        
        viewModel.output.showTranslucentLoader
            .emit(to: ProgressHUD.rx.showTranslucentLoader)
            .disposed(by: disposeBag)
        
        viewModel.output.showReviewButton
            .emit(onNext: {[unowned self] value in
                if !value {
                    self.reviewButton.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        viewModel.output.showReviewView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = WriteReviewViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.modalTransitionStyle = .coverVertical
                self?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
