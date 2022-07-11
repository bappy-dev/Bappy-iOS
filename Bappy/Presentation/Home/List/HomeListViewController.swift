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

private let reuseIdentifier = "HangoutCell"
final class HomeListViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: HomeListViewModel
    private let disposeBag = DisposeBag()
    private let topView: HomeListTopView
    private let topSubView: HomeListTopSubView
    private let tableView = UITableView()
    
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
        configureTableView()
        configureRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func refresh() {
        self.tableView.refreshControl?.endRefreshing()
    }

    // MARK: Helpers
    private func configureTableView() {
        tableView.register(HangoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 390.0 * 333.0 + 11.0
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(topSubView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
extension HomeListViewController {
    private func bind() {
        viewModel.output.scrollToTop
            .emit(to: tableView.rx.scrollToTop)
            .disposed(by: disposeBag)
        
        viewModel.output.hangouts
            .drive(tableView.rx.items) { tableView, row, hangout in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                ) as! HangoutCell
                cell.delegate = self
                cell.indexPath = indexPath
                cell.bind(with: hangout)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.output.showLocaleView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HomeLocaleViewController()
                viewController.modalPresentationStyle = .overCurrentContext
                self?.tabBarController?.present(viewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showSearchView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = HomeSearchViewController()
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
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
    }
}

// MARK: - UITableViewDelegate
extension HomeListViewController: HangoutCellDelegate {
    func moreButtonTapped(indexPath: IndexPath) {
        viewModel.input.moreButtonTapped.onNext(indexPath)
    }
    
    func likeButtonTapped(indexPath: IndexPath) {
        viewModel.input.likeButtonTapped.onNext(indexPath)
    }
}
