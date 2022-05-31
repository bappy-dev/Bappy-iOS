//
//  HangoutDetailViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/20.
//

import UIKit
import SnapKit

final class HangoutDetailViewController: UIViewController {
    
    // MARK: Properties
    private let titleTopView = TitleTopView(title: "Hangout", subTitle: "Detail page")
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageSectionView = HangoutImageSectionView()
    private let mainSectionView = HangoutMainSectionView()
    private let mapSectionView = HangoutMapSectionView()
    private let planSectionView = HangoutPlanSectionView()
    private let participantsSectionView = HangoutParticipantsSectionView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Edit",
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.roboto(size: 18.0)
                ]),
            for: .normal)
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "bappy_yellow")
        button.setAttributedTitle(
            NSAttributedString(
                string: "JOIN",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 18.0, family: .Medium)
                ]),
            for: .normal)
        button.layer.cornerRadius = 11.5
        button.addBappyShadow()
        button.addTarget(self, action: #selector(joinButtonHandler), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
        layout()
        addKeyboardObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStatusBarStyle(statusBarStyle: .lightContent)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setStatusBarStyle(statusBarStyle: .darkContent)
    }
    
    // MARK: Actions
    @objc
    private func backButtonHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func joinButtonHandler() {
        let popupView = SigninPopupViewController()
        popupView.modalPresentationStyle = .overCurrentContext
        present(popupView, animated: false)
    }
    
    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY
        self.scrollView.contentInset.bottom = keyboardHeight
    }
    
    // MARK: Helpers
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setStatusBarStyle(statusBarStyle: UIStatusBarStyle) {
        guard let navigationController = navigationController as? BappyNavigationViewController else { return }
        navigationController.statusBarStyle = statusBarStyle
    }
    
    private func configure() {
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
        mainSectionView.delegate = self
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        contentView.addSubview(imageSectionView)
        imageSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(mainSectionView)
        mainSectionView.snp.makeConstraints {
            $0.top.equalTo(imageSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(mapSectionView)
        mapSectionView.snp.makeConstraints {
            $0.top.equalTo(mainSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(planSectionView)
        planSectionView.snp.makeConstraints {
            $0.top.equalTo(mapSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(participantsSectionView)
        participantsSectionView.snp.makeConstraints {
            $0.top.equalTo(planSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.top.equalTo(participantsSectionView.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(157.0)
            $0.height.equalTo(43.0)
            $0.bottom.equalToSuperview().inset(42.0)
        }
        
        view.addSubview(titleTopView)
        titleTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.top)
            $0.height.equalTo(141.0)
        }
        
        titleTopView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(7.3)
            $0.width.height.equalTo(44.0)
        }
        
        titleTopView.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.trailing.equalToSuperview().inset(18.5)
            $0.width.height.equalTo(44.0)
        }
    }
}

// MARK: - HangoutMainSectionViewDelegate
extension HangoutDetailViewController: HangoutMainSectionViewDelegate {
    func didTapReportButton() {
        let viewController = ReportViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
