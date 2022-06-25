//
//  OpenMapPopupViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OpenMapPopupViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: OpenMapPopupViewModel
    private let disposBag = DisposeBag()
    
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
        label.text = "Open map app"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 30.0, family: .Medium)
        label.textAlignment = .center
        return label
    }()
    
    private let googleMapButton = UIButton()
    private let kakaoMapButton = UIButton()
    
    // MARK: Lifecycle
    init(viewModel: OpenMapPopupViewModel) {
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
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateDismissView()
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
        googleMapButton.setImage(UIImage(named: "googlemap_icon"), for: .normal)
        kakaoMapButton.setImage(UIImage(named: "kakaomap_icon"), for: .normal)
    }
    
    private func layout() {
        let hStackView = UIStackView(arrangedSubviews: [googleMapButton, kakaoMapButton])
        hStackView.axis = .horizontal
        hStackView.spacing = 52.0
        hStackView.distribution = .fillEqually
        
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(21.0)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22.0)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(31.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(117.0)
            $0.bottom.equalToSuperview().inset(27.0)
        }
    }
}

// MARK: - Bind
extension OpenMapPopupViewController {
    private func bind() {
        googleMapButton.rx.tap
            .bind(to: viewModel.input.googleMapButtonTapped)
            .disposed(by: disposBag)
        
        kakaoMapButton.rx.tap
            .bind(to: viewModel.input.kakaoMapButtonTapped)
            .disposed(by: disposBag)
        
        viewModel.output.openGoogleMap
            .emit(onNext: { url in
                if let url = url { UIApplication.shared.open(url) }
            })
            .disposed(by: disposBag)
        
        viewModel.output.openKakaoMap
            .emit(onNext: { url in
                if let url = url { UIApplication.shared.open(url) }
            })
            .disposed(by: disposBag)
    }
}
