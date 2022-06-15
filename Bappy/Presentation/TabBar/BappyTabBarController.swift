//
//  BappyTabBarController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class BappyTabBarController: UITabBarController {
    
    // MARK: Properties
    private var isLayoutSet: Bool = false
    private var isHomeButtonSelected: Bool = false {
        didSet {
            let image = isHomeButtonSelected
            ? UIImage(named: "tab_home_selected")
            : UIImage(named: "tab_home_unselected")
            homeImageView.image = image
        }
    }
    
    private var isProfileButtonSelected: Bool = false {
        didSet {
            let image = isProfileButtonSelected
            ? UIImage(named: "tab_profile_selected")
            : UIImage(named: "tab_profile_unselected")
            profileImageView.image = image
        }
    }
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(homeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let homeImageView = UIImageView()
    
    private let homeLabel: UILabel = {
        let label = UILabel()
        label.text = "HOME"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 10.0)
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView = UIImageView()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 10.0)
        return label
    }()
    
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "tab_write"), for: .normal)
        button.addTarget(self, action: #selector(writeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureViewController()
        object_setClass(self.tabBar, BappyTabBar.self)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if !isLayoutSet {
            bottomInset = view.safeAreaInsets.bottom
            isLayoutSet = true
        }
    }
    
    // MARK: Actions
    @objc
    private func homeButtonHandler() {
        if isHomeButtonSelected, let navigationController = self.selectedViewController as? BappyNavigationViewController {
            navigationController.popToRootViewController(animated: true)
            return
        }
        
        self.selectedIndex = 0
        isHomeButtonSelected = true
        isProfileButtonSelected = false
    }
    
    @objc
    private func profileButtonHandler() {
        if isProfileButtonSelected, let navigationController = self.selectedViewController as? BappyNavigationViewController {
            navigationController.popToRootViewController(animated: true)
            return
        }
        
        self.selectedIndex = 1
        isHomeButtonSelected = false
        isProfileButtonSelected = true
    }
    
    @objc
    private func writeButtonHandler() {
        let rootViewController = HangoutMakeViewController()
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        viewController.navigationBar.isHidden = true
        present(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func configureViewController() {
        let homeListRootViewController = HomeListViewController()
        let homeListViewController = BappyNavigationViewController(rootViewController: homeListRootViewController)
        homeListViewController.navigationBar.isHidden = true
        
        let profileRootViewController = ProfileViewController()
        let profileViewController = BappyNavigationViewController(rootViewController:  profileRootViewController)
        profileViewController.navigationBar.isHidden = true
        
        viewControllers = [homeListViewController, profileViewController]
        
        tabBar.backgroundColor = .white
        isHomeButtonSelected = true
        isProfileButtonSelected = false
    }
    
    private func layout() {
        guard let items = tabBar.items else { return }
        for item in items { item.isEnabled = false }
        
        let hStackView = UIStackView(arrangedSubviews: [homeButton, profileButton])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 70.0
        
        tabBar.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        homeButton.addSubview(homeImageView)
        homeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(33.0)
        }
        
        homeButton.addSubview(homeLabel)
        homeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(homeImageView.snp.bottom).offset(4.0)
        }
        
        profileButton.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(homeImageView)
            $0.width.height.equalTo(35.0)
        }
        
        profileButton.addSubview(profileLabel)
        profileLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(homeLabel)
        }
        
        tabBar.addSubview(writeButton)
        writeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48.0)
        }
    }
}
