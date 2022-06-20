//
//  HomeListViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

private let reuseIdentifier = "HangoutCell"
final class HomeListViewController: UIViewController {
    
    // MARK: Properties
    private var hasShown: Bool = false
    
    private let topView = HomeListTopView()
    private let topSubView = HomeListTopSubView()
    private let tableView = UITableView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
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
        tableView.dataSource = self
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

// MARK: - UITableViewDataSource
extension HomeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HangoutCell
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeListViewController: HangoutCellDelegate {
    func showDetailView(_ indexPath: IndexPath) {
        let viewController = HangoutDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
