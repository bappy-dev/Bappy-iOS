//
//  RegisterCompletedViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RegisterCompletedViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: RegisterCompletedViewModel
    private let disposeBag = DisposeBag()
    
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.isHidden = true
        return view
    }()
    
    private let dimmedView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Account completed!"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 28.0, family: .Bold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_excited")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Wanna fill in your bio?"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyYellow
        button.setBappyTitle(
            title: "Okay!",
            font: .roboto(size: 24.0, family: .Medium)
        )
        button.layer.cornerRadius = 21.0
        return button
    }()
    
    private let forwardImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14.0, weight: .medium)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: configuration)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .bappyBrown
        return imageView
    }()
    
    private let laterButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12.0, weight: .regular)
        let image = UIImage(systemName: "chevron.forward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setBappyTitle(
            title: "Maybe later ",
            font: .roboto(size: 13.0, family: .Light),
            hasUnderline: true
        )
        return button
    }()
    
    private let completeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popup_complete")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Lifecycle
    init(viewModel: RegisterCompletedViewModel) {
        self.viewModel = viewModel
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
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .transitionCrossDissolve) {
            self.containerView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        containerView.addBappyShadow(shadowOffsetHeight: 2.0)
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(27.0)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46.0)
            $0.leading.trailing.equalToSuperview().inset(21.0)
        }
        
        containerView.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(164.0)
            $0.height.equalTo(164.0)
        }
        
        containerView.addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(30.0)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(okButton)
        okButton.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(44.0)
            $0.trailing.equalToSuperview().inset(43.0)
            $0.height.equalTo(42.0)
        }
        
        okButton.addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        containerView.addSubview(laterButton)
        laterButton.snp.makeConstraints {
            $0.top.equalTo(okButton.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        containerView.addSubview(completeImageView)
        completeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(containerView.snp.top)
        }
    }
}

// MARK: - Bind
extension RegisterCompletedViewController {
    private func bind() {
        okButton.rx.tap
            .bind(to: viewModel.input.okayButtonTapped)
            .disposed(by: disposeBag)
        
        laterButton.rx.tap
            .bind(to: viewModel.input.laterButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.switchToMainView
            .observe(on: MainScheduler.instance)
            .bind(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToMainView(viewModel: viewModel, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.moveToEditProfileView
            .observe(on: MainScheduler.instance)
            .bind(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToMainView(viewModel: viewModel, animated: true, completion: { _ in print("DEBUG: com")} )
//                sceneDelegate.switchRootViewToMainView(viewModel: viewModel, animated: true) { tabBarController in
//                    print("DEBUG: Completion")
//                    guard let navigationController = tabBarController?.selectedViewController
//                            as? UINavigationController else { return }
//                    let viewController = ProfileDetailViewController()
//                    viewController.hidesBottomBarWhenPushed = true
//                    print("DEBUG: navi \(navigationController.viewControllers)")
//                    navigationController.pushViewController(viewController, animated: false)
//                }
            })
            .disposed(by: disposeBag)
    }
}
