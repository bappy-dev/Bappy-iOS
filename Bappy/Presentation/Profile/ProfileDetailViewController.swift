//
//  ProfileDetailViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit

final class ProfileDetailViewController: UIViewController {
    
    // MARK: Properties
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .bappyBrown
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profile_edit"), for: .normal)
//        button.isHidden = true
        return button
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView = ProfileDetailMainView()
    private let introduceView = ProfileDetailIntroduceView()
    private let affiliationView = ProfileDetailAffiliationView()
    private let languageView = ProfileDetailLanguageView()
    private let personalityView = ProfileDetailPersonalityView()
    private let interestsView = ProfileDetailInterestsView()
    
    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func backButtonHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(9.0)
            $0.leading.equalToSuperview().inset(9.0)
            $0.width.height.equalTo(44.0)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(65.0)
            $0.height.equalTo(44.0)
            $0.trailing.equalToSuperview().inset(31.0)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(10.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(introduceView)
        introduceView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(affiliationView)
        affiliationView.snp.makeConstraints {
            $0.top.equalTo(introduceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(languageView)
        languageView.snp.makeConstraints {
            $0.top.equalTo(affiliationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(personalityView)
        personalityView.snp.makeConstraints {
            $0.top.equalTo(languageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(interestsView)
        interestsView.snp.makeConstraints {
            $0.top.equalTo(personalityView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
