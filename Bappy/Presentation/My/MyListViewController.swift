//
//  MyListViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

private let reuseIdentifier = "HangoutCell"
final class MyListViewController: UIViewController {
    
    // MARK: Properties
    private let myTopView = MyListTopView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HangoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 390.0 * 333.0 + 11.0
        return tableView
    }()

    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)

        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubview(myTopView)
        myTopView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(myTopView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDataSource
extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HangoutCell
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = HangoutDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - MyListTopViewDelegate
extension MyListViewController: MyListTopViewDelegate {
    func fetchMyHangout() {
        //
    }
    
    func fetchSavedHangout() {
        //
    }
}
