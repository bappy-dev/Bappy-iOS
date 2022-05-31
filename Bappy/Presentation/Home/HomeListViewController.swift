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
    private let headerView = SortingHeaderView()
    private let tableView = UITableView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 임시
        
        guard !hasShown else { return }
        let rootViewController = BappyLoginViewController()
        rootViewController.modalPresentationStyle = .fullScreen
        self.present(rootViewController, animated: false)
        hasShown = true
    }
    
    // MARK: Helpers
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HangoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 180.0 + view.frame.width * 9.0 / 16.0
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = 30.0
    }
    
    private func configure() {
        view.backgroundColor = .white
        tableView.backgroundColor = UIColor(named: "bappy_lightgray")
        topView.delegate = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.top)
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
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = HangoutDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - HomeListTopViewDelegate
extension HomeListViewController: HomeListTopViewDelegate {
    func showDateFilterView() {
        
    }
    
    func showWriteView() {
        let rootViewController = HangoutMakeViewController()
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        viewController.navigationBar.isHidden = true
        present(viewController, animated: true)
    }
}
