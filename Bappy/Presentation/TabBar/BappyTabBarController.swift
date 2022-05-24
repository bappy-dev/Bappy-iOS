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
        object_setClass(self.tabBar, BappyTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        print("DEBUG: \(tabBar.safeAreaInsets.bottom)")
//        tabBar.frame.origin.y = view.frame.height - 89.0
        let offset = (-tabBar.safeAreaInsets.bottom) * 29.0 / 34.0 + 25
        let top = tabBar.safeAreaInsets.bottom * 6.0 / 17.0 - 12.0
        let bottom = -6.0 - top
        tabBar.items?.forEach { item in
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1 * offset)
            item.imageInsets = UIEdgeInsets(top: top, left: -3.0, bottom: bottom, right: -3.0)
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
        self.selectedIndex = 1
    }
    
    private func templateNavigationController(tabTitle: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = BappyNavigationViewController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = tabTitle
        navigationController.tabBarItem.image = unselectedImage?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        navigationController.navigationBar.isHidden = true
        print("DEBUG: dfdf \(tabBar)")
//        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: -3, bottom: -6, right: -3)
        navigationController.tabBarItem.setTitleTextAttributes([
            .foregroundColor: UIColor(named: "bappy_brown")!,
            .font: UIFont.roboto(size: 7.0)
        ], for: .normal)
        return navigationController
    }
}
