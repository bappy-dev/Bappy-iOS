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
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

final class HangoutDetailViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: HangoutDetailViewModel
    private var disposeBag = DisposeBag()
    
    private let titleTopView = TitleTopView(title: "Hangout", subTitle: "Detail page")
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageSectionView: HangoutImageSectionView
    private let mainSectionView: HangoutMainSectionView
    private let mapSectionView: HangoutMapSectionView
    private let planSectionView: HangoutPlanSectionView
    private var participantsSectionView: HangoutParticipantsSectionView
    
    private let hangoutButton = HangoutButton()
    private let editButton = HangoutButton(state: .edit)
    private let reviewButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .bappyYellow
        btn.setBappyTitle(
            title: "Write Reviews!",
            font: .roboto(size: 28.0, family: .Bold))
        btn.addBappyShadow()
        btn.isEnabled = true
        
        btn.layer.cornerRadius = 29.5
        btn.snp.makeConstraints {
            $0.width.equalTo(215.0)
            $0.height.equalTo(59.0)
        }
        btn.clipsToBounds = true
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing =  18
        view.alignment = .center
        let horizonStackView = UIStackView()
        horizonStackView.axis = .horizontal
        horizonStackView.spacing = 20
        horizonStackView.distribution = .fillEqually
        horizonStackView.addArrangedSubviews([hangoutButton, editButton])
        view.addArrangedSubviews([horizonStackView, reviewButton, reportButton])
        return view
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrowshape.turn.up.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
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
        contentView.addSubviews([imageSectionView, mainSectionView, mapSectionView, planSectionView, participantsSectionView, stackView])
        
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
        
        reportButton.snp.makeConstraints {
            $0.width.equalTo(250.0)
            $0.height.equalTo(44.0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(participantsSectionView.snp.bottom).offset(33.0)
            $0.leading.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(90.0)
            $0.height.greaterThanOrEqualTo(59).priority(.required)
            $0.height.lessThanOrEqualTo(121).priority(.high)
            $0.leading.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
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
        
        editButton.snp.updateConstraints {
            $0.width.equalTo(ScreenUtil.width / 2 - 30)
        }
    }
}
// MARK: - Bind
extension HangoutDetailViewController {
    private func bind() {
        self.rx.viewDidAppear
            .bind { _ in
                UserDefaults.standard.setValue(Date(), forKey: "detail_start")
            }.disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in }
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
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
            .bind(to: viewModel.input.shareButtonTapped)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind(to: viewModel.input.editButtonTapped)
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .withLatestFrom(scrollView.rx.contentOffset)
            .map(\.y)
            .filter { $0 <= 0 }
            .map { [weak self] y -> CGFloat in
                let imageHeight = self?.imageSectionView.frame.height ?? 0
                return imageHeight - y }
            .bind(to: viewModel.input.imageHeight)
            .disposed(by: disposeBag)
        
        viewModel.output.acitivityView
            .compactMap { $0 }
            .emit(onNext: { [weak self] activityVC in
                if let self = self {
                    activityVC.userActivity?.delegate = self
                }
                
                activityVC.popoverPresentationController?.sourceView = self?.view
                self?.present(activityVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        viewModel.output.showLikedPeopleList
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let vc = LikedPeopleListViewController(viewModel: viewModel)
                let presentVC = BappyPresentBaseViewController(baseViewController: vc, title: "Like")
                presentVC.modalPresentationStyle = .overCurrentContext
                self?.present(presentVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showBlockViewController
            .compactMap { $0 }
            .emit { [weak self] vc in
                guard let self = self else { return }
              
                vc.okButton.rx.tap
                    .bind {
                        EventLogger.logEvent("block_join_hangout")
                        self.navigationController?.popViewController(animated: true)
                    }.disposed(by: self.disposeBag)

                UIView.animate(withDuration: 0.4, delay: 0.0) { [unowned self] in
                    self.view.backgroundColor = .clear
                } completion: { _ in
                    self.addChild(vc)
                    self.view.addSubview(vc.view)
                }
            }.disposed(by: disposeBag)
        
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
        
        viewModel.output.showMakeViewModel
            .compactMap { $0 }
            .emit { [weak self] vm in
                let vc = HangoutMakeViewController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.output.showEditButton
            .emit { [weak self] bool in
                self?.editButton.isHidden = !bool
                
                self?.hangoutButton.snp.updateConstraints {
                    $0.width.equalTo(!bool ? 250 : ScreenUtil.width / 2 - 30)
                }
            }.disposed(by: disposeBag)
        
        viewModel.output.hangoutButtonState
            .emit(onNext: { [weak self] state in
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

extension HangoutDetailViewController: NSUserActivityDelegate { }
