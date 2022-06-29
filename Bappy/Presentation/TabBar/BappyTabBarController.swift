//
//  BappyTabBarController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BappyTabBarController: UITabBarController {
    
    // MARK: Properties
    private let viewModel: BappyTabBarViewModel
    private let disposeBag = DisposeBag()
    
    private let homeButton = UIButton()
    private let profileButton = UIButton()
    private let writeButton = UIButton()
    private let homeImageView = UIImageView()
    private let profileImageView = UIImageView()
    
    private let homeLabel: UILabel = {
        let label = UILabel()
        label.text = "HOME"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 10.0)
        return label
    }()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 10.0)
        return label
    }()
    
    // MARK: Lifecycle
    init(viewModel: BappyTabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        let homeListViewModel = viewModel.subViewModels.homeListViewModel
        let profileViewModel = viewModel.subViewModels.profileViewModel
        
        configureViewController(homeListViewModel: homeListViewModel, profileViewModel: profileViewModel)
        configure()
        layout()
        bind()
        object_setClass(self.tabBar, BappyTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func updateHomeButton(isSelected: Bool) {
        let image = isSelected
        ? UIImage(named: "tab_home_selected")
        : UIImage(named: "tab_home_unselected")
        homeImageView.image = image
    }
    
    private func updateProfileButton(isSelected: Bool) {
        let image = isSelected
        ? UIImage(named: "tab_profile_selected")
        : UIImage(named: "tab_profile_unselected")
        profileImageView.image = image
    }
    
    private func showWriteView(viewModel: HangoutMakeViewModel) {
        let rootViewController = HangoutMakeViewController(viewModel: viewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        viewController.navigationBar.isHidden = true
        present(viewController, animated: true)
    }
    
    private func configureViewController(homeListViewModel: HomeListViewModel, profileViewModel: ProfileViewModel) {
        let homeListRootViewController = HomeListViewController(viewModel: homeListViewModel)
        let homeListViewController = BappyNavigationViewController(rootViewController: homeListRootViewController)
        homeListViewController.navigationBar.isHidden = true
        
        let profileRootViewController = ProfileViewController(viewModel: profileViewModel)
        let profileViewController = BappyNavigationViewController(rootViewController:  profileRootViewController)
        profileViewController.navigationBar.isHidden = true
        
        viewControllers = [homeListViewController, profileViewController]
    }
    
    private func configure() {
        writeButton.setImage(UIImage(named: "tab_write"), for: .normal)
        tabBar.backgroundColor = .white
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

// MARK: - Bind
extension BappyTabBarController {
    private func bind() {
        self.rx.viewWillLayoutSubviews
            .take(1)
            .map { self.view.safeAreaInsets.bottom }
            .bind(onNext: { bottomInset = $0 })
            .disposed(by: disposeBag)
        
        homeButton.rx.tap
            .bind(to: viewModel.input.homeButtonTapped)
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .bind(to: viewModel.input.profileButtonTapped)
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind(to: viewModel.input.writeButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.seletedIndex
            .drive(self.rx.selectedIndex)
            .disposed(by: disposeBag)
        
        viewModel.output.isHomeButtonSelected
            .drive(onNext: { [weak self] isSelected in
                self?.updateHomeButton(isSelected: isSelected)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isProfileButtonSelected
            .drive(onNext: { [weak self] isSelected in
                self?.updateProfileButton(isSelected: isSelected)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.popToSelectedRootView
            .emit(onNext: {[weak self] _ in
                let navigationController = self?.selectedViewController as? UINavigationController
                navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showWriteView
            .emit(onNext: {[weak self] viewModel in
                self?.showWriteView(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
    }
}
