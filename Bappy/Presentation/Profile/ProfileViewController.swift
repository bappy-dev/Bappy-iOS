//
//  ProfileViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    // MARK: Properties
    private let titleTopView = TitleTopView(title: "Profile", subTitle: "Setting")
    private let scrollView = UIScrollView()
    private let contentView = ProfileView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
//        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStatusBarStyle(statusBarStyle: .lightContent)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        guard let navigationController = navigationController as? BappyNavigationViewController else { return }
        navigationController.statusBarStyle = statusBarStyle
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        view.addSubview(titleTopView)
        titleTopView.snp.makeConstraints {
//            let height = 141.0 + view.safeAreaInsets.top
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.top)
            $0.height.equalTo(141.0)
//            print("DEBUG: \(height)")
        }
    }
}
