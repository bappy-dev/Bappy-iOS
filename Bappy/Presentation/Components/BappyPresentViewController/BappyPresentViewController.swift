//
//  BappyPresentViewController.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/02.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

protocol BappyPresentDelegate: AnyObject {
    func leftButtonTapped()
    func rightButtonTapped()
}

final class BappyPresentBaseViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: BappyPresentDelegate?
    private let disposeBag = DisposeBag()
    
    private let maxDimmedAlpha: CGFloat = 0.3
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height - 90.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 27.0
        view.clipsToBounds = true
        return view
    }()
    
    private var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "  Close", style: .plain, target: nil, action: nil)
        button.setTitleTextAttributes([
            .font: UIFont.roboto(size: 18.0, family: .Medium)
            ], for: .normal)
        return button
    }()
    
    private var rightButton = UIBarButtonItem()
    
    private let dimmedView = UIView()
    
    private let childViewController: UINavigationController

    // MARK: Lifecycle
    init(baseViewController: UIViewController, title: String? = nil, leftBarButton: UIBarButtonItem? = nil, rightBarButton: UIBarButtonItem? = nil, backBarButton: UIBarButtonItem? =  nil) {
        let nav = UINavigationController(rootViewController: baseViewController)
        closeButton = leftBarButton ?? closeButton
        rightButton = rightBarButton ?? rightButton
        baseViewController.navigationController?.navigationBar.isTranslucent = false
        baseViewController.navigationItem.leftBarButtonItem = closeButton
        baseViewController.navigationItem.backBarButtonItem = backBarButton
        baseViewController.navigationItem.rightBarButtonItem = rightButton
        baseViewController.title = title
        self.childViewController = nav
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
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

// MARK: - Bind
extension BappyPresentBaseViewController {
    private func bind() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.animateDismissView()
                self?.delegate?.leftButtonTapped()
            }.disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind { [weak self] in
                self?.animateDismissView()
                self?.delegate?.rightButtonTapped()
            }.disposed(by: disposeBag)
    }
}
