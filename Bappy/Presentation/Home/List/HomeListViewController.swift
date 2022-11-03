//
//  HomeListViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeListViewController: UIViewController {
    
    // MARK: Properties
    let viewModel: HomeListViewModel
    private let disposeBag = DisposeBag()
    private let topView: HomeListTopView
    private let topSubView: HomeListTopSubView
    private let holderView = HomeListHolderView()
    
    private let noResultView = NoResultView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HangoutCell.self, forCellReuseIdentifier: HangoutCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 390.0 * 333.0 + 11.0
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .white
        refreshControl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return refreshControl
    }()
    
    private let bottomSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        spinner.frame.size.height = 36.0
        return spinner
    }()
    
    // MARK: Lifecycle
    init(viewModel: HomeListViewModel) {
        let topViewModel = viewModel.subViewModels.topViewModel
        let topSubViewModel = viewModel.subViewModels.topSubViewModel
        self.topView = HomeListTopView(viewModel: topViewModel)
        self.topSubView = HomeListTopSubView(viewModel: topSubViewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = bottomSpinner
        noResultView.isHidden = true
    }
    
    private func layout() {
        self.view.addSubviews([topView, topSubView, tableView, holderView, noResultView])
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        topSubView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topSubView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        holderView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        noResultView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(10)
        }
    }
}

// MARK: - Bind
extension HomeListViewController {
    private func bind() {
//        self.rx.viewWillAppear
//            .bind(to: viewModel.input.viewWillAppear)
//            .disposed(by: disposeBag)
        
        self.rx.viewWillDisappear
            .bind(to: viewModel.input.viewWillDisappear)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refresh)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map(\.indexPath.row)
            .bind(to: viewModel.input.willDisplayRow)
            .disposed(by: disposeBag)
        
        viewModel.output.scrollToTop
            .emit(to: tableView.rx.scrollToTop)
            .disposed(by: disposeBag)
        
        viewModel.output.cellViewModels
            .skip(1)
            .map { [weak self] viewModels in self?.noResultView.isHidden = !viewModels.isEmpty; return viewModels }
            .drive(tableView.rx.items(cellIdentifier: HangoutCell.reuseIdentifier, cellType: HangoutCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        viewModel.output.showLocaleView
            .compactMap { $0 }
            .emit(onNext: { [weak self] bappyVC in
                bappyVC.modalPresentationStyle = .overCurrentContext
                self?.tabBarController?.present(bappyVC, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSearchView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HomeSearchViewController(viewModel: viewModel)
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showFilteredView
            .compactMap { $0 }
            .emit { [weak self] viewModel in
                let viewController = HomeFilteredViewController(viewModel: viewModel)
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.output.showSortingView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let point: CGPoint = .init(
                    x: self.topSubView.frame.maxX - 7.0,
                    y: self.topSubView.frame.maxY - 12.0
                )
                let viewController = SortingOrderViewController(viewModel: viewModel, upperRightPoint: point)
                viewController.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showDetailView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HangoutDetailViewController(viewModel: viewModel)
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hideHolderView
            .distinctUntilChanged()
            .emit(to: holderView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.endRefreshing
            .map { _ in false }
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.output.spinnerAnimating
            .distinctUntilChanged()
            .emit(to: bottomSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.spinnerAnimating
            .distinctUntilChanged()
            .emit(onNext: { [weak self] animate in
                self?.tableView.tableFooterView = animate ? self?.bottomSpinner : nil
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLocationSettingAlert
            .emit(onNext: { [weak self] _ in
                let title = "Location setting is required"
                let message = "Please set the location\nto view hangouts in the\n'Nearest' order."
                let actionTitle = "Setting"
                let action = Alert.Action(
                    actionTitle: actionTitle,
                    actionStyle: .disclosure) {
                        let rootViewController = LocaleSettingViewController(viewModel: LocaleSettingViewModel())
                        let viewController = BappyPresentBaseViewController(baseViewController: rootViewController,
                                                                            title: "Location Setting",
                                                                            leftBarButton: nil,
                                                                            rightBarButton: nil,
                                                                            backBarButton: UIBarButtonItem(title: "Setting", style: .plain, target: nil, action: nil))
                        viewController.modalPresentationStyle = .overCurrentContext
                        self?.tabBarController?.present(viewController, animated: false)
                    }
                let alert = Alert(
                    title: title,
                    message: message,
                    bappyStyle: .happy,
                    action: action)
                self?.tabBarController?.showAlert(alert)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSignInAlert
            .compactMap { $0 }
            .emit(onNext: { [weak self] title in
                let alert = SignInAlertController(title: title)
                self?.tabBarController?.present(alert, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
