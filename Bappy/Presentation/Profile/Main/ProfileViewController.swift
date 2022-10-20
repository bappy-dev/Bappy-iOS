//
//  ProfileViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let hangoutReuseIdentifier = "ProfileHangoutCell"
private let referenceReuseIdentifier = "ProfileReferenceCell"
final class ProfileViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()
    
    private let titleTopView = TitleTopView(title: "Profile", subTitle: "Bappy user")
    private let headerView: ProfileHeaderView
    private let settingButton = UIButton()
    private let holderView = ProfileHangoutHolderView()
    private let noHangoutsView = NoHangoutsView()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let tableView: ProfileTableView = {
        let tableView = ProfileTableView()
        tableView.backgroundColor = .bappyLightgray
        tableView.register(ProfileHangoutCell.self, forCellReuseIdentifier: hangoutReuseIdentifier)
        tableView.register(ProfileReferenceCell.self, forCellReuseIdentifier: referenceReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 157.0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var signInAlert: SignInAlertController = {
        let title = "Sign in and make\nyour own profile!"
        let alert = SignInAlertController(title: title)
        alert.canDismissByTouch = false
        alert.isContentsBlurred = true
        return alert
    }()
    
    // MARK: Lifecycle
    init(viewModel: ProfileViewModel) {
        let headerViewModel = viewModel.subViewModels.headerViewModel
        self.headerView = ProfileHeaderView(viewModel: headerViewModel)
        self.viewModel = viewModel
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
    private func showSignInAlert() {
        self.addChild(signInAlert)
        view.addSubview(signInAlert.view)
        signInAlert.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        signInAlert.didMove(toParent: self)
    }
    
    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        let navigationController = navigationController?.tabBarController?.navigationController as? BappyNavigationViewController
        navigationController?.statusBarStyle = statusBarStyle
    }
    
    private func configure() {
        view.backgroundColor = .bappyLightgray
        
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = 352.0
        settingButton.setImage(UIImage(named: "profile_setting"), for: .normal)
        settingButton.isHidden = true
        tableView.tableFooterView = noHangoutsView
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(titleTopView)
        titleTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(94.0)
            $0.bottom.equalTo(tableView.snp.top)
        }
        
        titleTopView.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(21.3)
            $0.bottom.equalToSuperview().inset(48.6)
        }
        
        titleTopView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(7.3)
            $0.width.height.equalTo(44.0)
        }
        
        tableView.addSubview(holderView)
        holderView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
extension ProfileViewController {
    private func bind() {
        self.rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .withLatestFrom(tableView.rx.contentOffset)
            .observe(on: MainScheduler.asyncInstance)
            .filter { $0.y < 0 }
            .map { CGPoint(x: $0.x, y: 0) }
            .bind(to: tableView.rx.contentOffset)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .bind(to: viewModel.input.settingButtonTapped)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.scrollToTop
            .emit(to: tableView.rx.scrollToTop)
            .disposed(by: disposeBag)
        
        viewModel.output.results
            .drive(tableView.rx.items) { tableView, row, item in
                if let item = item as? Hangout {
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: hangoutReuseIdentifier,
                        for: IndexPath(row: row, section: 0)
                    ) as! ProfileHangoutCell
                    cell.bind(with: item)
                    cell.selectionStyle = .none
                    return cell
                } else if let item = item as? ReferenceCellState {
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: referenceReuseIdentifier,
                        for: IndexPath(row: row, section: 0)
                    ) as! ProfileReferenceCell
                    cell.bind(with: item)
                    cell.selectionStyle = .none
                    return cell
                }
                fatalError()
            }
            .disposed(by: disposeBag)
        
        viewModel.output.hideNoHangoutsView
            .emit(to: noHangoutsView.rx.hide)
            .disposed(by: disposeBag)
        
        viewModel.output.showSettingView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = ProfileSettingViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .fullScreen
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showProfileDetailView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = ProfileDetailViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .fullScreen
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showHangoutDetailView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HangoutDetailViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .fullScreen
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGotoReviewView
            .compactMap { $0 }
            .emit(onNext: { [weak self] hangoutID in
                let viewController = GoToReviewViewController(viewModel: GotoReviewViewModel(dependency: GotoReviewViewModel.Dependency(hangoutID: hangoutID)))
                viewController.modalPresentationStyle = .overCurrentContext
                self?.present(viewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideSettingButton
            .emit(to: settingButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldHideBackButton
            .emit(to: backButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.showAlert
            .emit(onNext: { [weak self] _ in self?.showSignInAlert() })
            .disposed(by: disposeBag)
        
        viewModel.output.popView
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hideHolderView
            .distinctUntilChanged()
            .emit(to: holderView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.showTranslucentLoader)
            .disposed(by: disposeBag)
    }
}
