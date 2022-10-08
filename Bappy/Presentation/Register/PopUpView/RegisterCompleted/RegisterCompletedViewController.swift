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
import Lottie

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
            font: .roboto(size: 24.0, family: .Medium))
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
            hasUnderline: true)
        return button
    }()
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "success")
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    // MARK: Lifecycle
    init(viewModel: RegisterCompletedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
        playAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureShadow()
    }
    
    // MARK: Animations
    private func playAnimation() {
        animationView.play()
    }
    
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
    private func configureShadow() {
        containerView.addBappyShadow(shadowOffsetHeight: 2.0)
    }
    
    private func configure() {
        view.backgroundColor = .clear
    }
    
    private func layout() {
        view.addSubviews([dimmedView, containerView])
        containerView.addSubviews([titleLabel, bappyImageView, captionLabel, okButton, laterButton, animationView])
        okButton.addSubview(forwardImageView)
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(27.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46.0)
            $0.leading.trailing.equalToSuperview().inset(21.0)
        }
        
        bappyImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(164.0)
            $0.height.equalTo(164.0)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(30.0)
            $0.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(44.0)
            $0.trailing.equalToSuperview().inset(43.0)
            $0.height.equalTo(42.0)
        }
        
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        laterButton.snp.makeConstraints {
            $0.top.equalTo(okButton.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(5.0)
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(containerView.snp.top)
            $0.width.height.equalTo(80.0)
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
            .compactMap { $0 }
            .emit(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToMainView(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.moveToEditProfileView
            .compactMap { $0 }
            .emit(onNext: { viewModels in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToMainView(viewModel: viewModels.tabBarViewModel) { navigationController in
                    let editViewController = ProfileEditViewController(viewModel: viewModels.editViewModel)
                    navigationController?.pushViewController(editViewController, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
}
