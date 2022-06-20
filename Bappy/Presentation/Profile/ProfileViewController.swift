//
//  ProfileViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

private let reuseIdentifier = "ProfileHangoutCell"

final class ProfileViewController: UIViewController {
    
    // MARK: Properties
    private var count: Int = 0
    private let titleTopView = TitleTopView(title: "Profile", subTitle: "Setting")
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profile_setting"), for: .normal)
        button.addTarget(self, action: #selector(settingButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .bappyLightgray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileHangoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 157.0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let headerView = ProfileHeaderView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStatusBarStyle(statusBarStyle: .lightContent)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.count = 10
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setStatusBarStyle(statusBarStyle: .darkContent)
    }
    
    // MARK: Actions
    @objc
    private func settingButtonHandler() {
        let viewController = ProfileSettingViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        guard let navigationController = navigationController as? BappyNavigationViewController else { return }
        navigationController.statusBarStyle = statusBarStyle
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = 352.0
        headerView.delegate = self
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
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileHangoutCell
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledOffset = scrollView.contentOffset.y
        if scrolledOffset < 0 { scrollView.contentOffset.y = 0 }
    }
}

// MARK: - ProfileHeaderViewDelegate
extension ProfileViewController: ProfileHeaderViewDelegate {
    func moreButtonDidTap() {
        let viewController = ProfileDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
