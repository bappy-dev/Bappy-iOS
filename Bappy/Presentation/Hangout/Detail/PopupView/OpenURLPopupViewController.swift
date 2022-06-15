//
//  OpenURLPopupViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/06.
//

import UIKit
import SnapKit

protocol OpenURLPopupViewControllerDelegate: AnyObject {
    
}

final class OpenURLPopupViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: OpenURLPopupViewControllerDelegate?
    
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.isHidden = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Open map app"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 30.0, family: .Medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var googleMapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "googlemap_icon"), for: .normal)
        button.addTarget(self, action: #selector(openGoogleMapURL), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoMapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaomap_icon"), for: .normal)
        button.addTarget(self, action: #selector(openKakaoMapURL), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
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
    
    // MARK: Actions
    @objc
    private func openGoogleMapURL() {
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc
    private func openKakaoMapURL() {
        if let url = URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        containerView.addBappyShadow(shadowOffsetHeight: 2.0)
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
