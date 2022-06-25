//
//  HomeLocaleViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeLocaleViewController: UIViewController {
    
    // MARK: Properties
    private let maxDimmedAlpha: CGFloat = 0.3
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height - 90.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 27.0
        view.clipsToBounds = true
        return view
    }()
    
    private let dimmedView = UIView()
    
    private let childViewController: UINavigationController

    // MARK: Lifecycle
    init() {
        let rootViewController = LocaleSettingViewController()
        self.childViewController = UINavigationController(rootViewController: rootViewController)
        super.init(nibName: nil, bundle: nil)
        
        rootViewController.delegate = self
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.backgroundColor = .black
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Actions
    @objc
    private func closeButtonHandler() {
        animateDismissView()
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        childViewController.navigationBar.backgroundColor = .white
        childViewController.navigationBar.tintColor = .bappyYellow
        childViewController.navigationBar.titleTextAttributes = [
            .font: UIFont.roboto(size: 20.0, family: .Bold),
            .foregroundColor: UIColor.bappyBrown
        ]
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().inset(-defaultHeight)
        }
        
        self.addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        childViewController.didMove(toParent: self)
    }
}

extension HomeLocaleViewController: LocaleSettingViewControllerDelegate {
    func closeButtonTapped() {
        animateDismissView()
    }
}
