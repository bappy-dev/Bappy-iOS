//
//  BappyTabBarController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit

final class BappyTabBarController: UITabBarController {
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.frame.size.height = 93.5
        tabBar.frame.origin.y = view.frame.height - 93.5
        tabBar.items?.forEach { item in
            let offset = (34.0 - tabBar.safeAreaInsets.bottom) / 2
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1 * offset)
        }
    }
    
    // MARK: Helpers
    private func configureViewController() {
        let myListRootViewController = MyListViewController()
        let myListViewController = templateNavigationController(
            tabTitle: "MY",
            unselectedImage: UIImage(named: "tab_my_unselected"),
            selectedImage: UIImage(named: "tab_my_selected"),
            rootViewController: myListRootViewController)
        
        let homeListRootViewController = HomeListViewController()
        let homeListViewController = templateNavigationController(
            tabTitle: "HOME",
            unselectedImage: UIImage(named: "tab_home_unselected"),
            selectedImage: UIImage(named: "tab_home_selected"),
            rootViewController: homeListRootViewController)
        
        let profileRootViewController = ProfileViewController()
        let profileViewController = templateNavigationController(
            tabTitle: "PROFILE",
            unselectedImage: UIImage(named: "tab_profile_unselected"),
            selectedImage: UIImage(named: "tab_profile_selected"),
            rootViewController: profileRootViewController)
        
        viewControllers = [myListViewController, homeListViewController, profileViewController]
        
        tabBar.backgroundColor = .white
        self.selectedIndex = 2
    }
    
    private func templateNavigationController(tabTitle: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = BappyNavigationViewController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = tabTitle
        navigationController.tabBarItem.image = unselectedImage?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        navigationController.navigationBar.isHidden = true
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3)
        navigationController.tabBarItem.setTitleTextAttributes([
            .foregroundColor: UIColor(named: "bappy_brown")!,
            .font: UIFont.roboto(size: 7.0)
        ], for: .normal)
        return navigationController
    }
}
