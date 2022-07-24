//
//  BappyInitialViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BappyInitialViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: BappyInitialViewModel
    private let dispoesBag = DisposeBag()
    
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Lifecycle
    init(viewModel: BappyInitialViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func showUpdateAlert() {
        let appleID = "" // 나중에 AppStore Connect에서 확인
        let urlStr = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
        guard let url = URL(string: urlStr) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showNoticeAlert(notice: RemoteConfigValues.Notice) {
        let title = notice.noticeTitle
        let message = notice.noticeMessage
        let alert = BappyAlertController(title: title, message: message, bappyStyle: .happy)
        alert.canDismissByTouch = false
        self.present(alert, animated: false)
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-60.0)
            $0.width.height.equalTo(300.0)
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(-20.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(60.0)
        }
    }
}

// MARK: - Bind
extension BappyInitialViewController {
    private func bind() {
        viewModel.output.switchToSignInView
            .compactMap { $0 }
            .emit(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToSignInView(viewModel: viewModel)
            })
            .disposed(by: dispoesBag)

        viewModel.output.switchToMainView
            .compactMap { $0 }
            .emit(onNext: { viewModel in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.switchRootViewToMainView(viewModel: viewModel)
            })
            .disposed(by: dispoesBag)
        
        viewModel.output.showUpdateAlert
            .emit(onNext: { [weak self] _ in self?.showUpdateAlert() })
            .disposed(by: dispoesBag)
        
        viewModel.output.showNoticeAlert
            .compactMap { $0 }
            .emit(onNext: { [weak self] notice in self?.showNoticeAlert(notice: notice) })
            .disposed(by: dispoesBag)
        
    }
}
