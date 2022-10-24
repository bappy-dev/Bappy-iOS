//
//  WriteReviewViewController.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WriteReviewViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: WriteReviewViewModel
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    
    private let backButton = UIButton()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 20.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Review"
        return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .bappyGray
        divider.snp.makeConstraints { make in
            make.height.equalTo(1.0)
        }
        return divider
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = .bappyBrown
        label.text = "References make people behave and\nmake BAPPY a safer community."
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let targetsScrollView = UIScrollView()
    private let progressBarView = ProgressBarView()
    
    private let tagsView: ReviewSelectTagView
    
    private let moveWithKeyboardView: MoveWithKeyboardView

    // MARK: Lifecycle
    init(viewModel: WriteReviewViewModel) {
        self.viewModel = viewModel
        self.moveWithKeyboardView = MoveWithKeyboardView(viewModel: viewModel.subViewModels.moveWithKeyboardViewModel)
        self.tagsView = ReviewSelectTagView(viewModel: viewModel.subViewModels.reviewSelectTagViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, delay: 0.0) { [unowned self] in
            self.view.backgroundColor = .gray.withAlphaComponent(0.2)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }

    @objc
    private func touchesScrollView() {
        view.endEditing(true)
    }
    
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        targetsScrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }
    
    // MARK: Helpers
    private func updateButtonPostion(keyboardHeight: CGFloat) {
        let bottomPadding = (keyboardHeight != 0) ? view.safeAreaInsets.bottom : 0

        UIView.animate(withDuration: 0.4) {
            self.moveWithKeyboardView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomPadding - keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func configure() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20.0
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        
        backButton.setImage(UIImage(named: "chevron_back")?.withTintColor(.bappyYellow), for: .normal)
        backButton.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        
        targetsScrollView.showsHorizontalScrollIndicator = false
        
        addTapGestureOnScrollView()
        addTargets()
    }
    
    private func layout() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(510.0)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15.0)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(44.0)
        }
        
        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18.0)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(30.0)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(targetsScrollView)
        targetsScrollView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
            make.height.equalTo(48.0)
        }
        
        contentView.addSubview(progressBarView)
        progressBarView.snp.makeConstraints { make in
            make.top.equalTo(targetsScrollView.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(23.0)
        }
        
        contentView.addSubview(tagsView)
        tagsView.snp.makeConstraints { make in
            make.top.equalTo(progressBarView.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        contentView.addSubview(moveWithKeyboardView)
        
        moveWithKeyboardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addTargets() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 23.0
        
        targetsScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewModel.dependency.targetList.forEach { targetInfo in
            let profileImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = ProfileReferenceCell.profileImageViewWidth / 2.0
                imageView.clipsToBounds = true
                return imageView
            }()
            profileImageView.kf.setImage(with: targetInfo.profileImage, placeholder: UIImage(named: "no_profile_l"))
            profileImageView.snp.makeConstraints { make in
                make.width.height.equalTo(48.0)
            }
            
            stackView.addArrangedSubview(profileImageView)
        }
    }
    
}

// MARK: - Bind
extension WriteReviewViewController {
    private func bind() {
        self.rx.viewDidAppear
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                UIView.animate(withDuration: 0.4, delay: 0.0) { [unowned self] in
                    self.view.backgroundColor = .clear
                } completion: { _ in
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.shouldKeyboardHide
            .emit(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.progression
            .drive(progressBarView.rx.setProgression)
            .disposed(by: disposeBag)
        
        viewModel.output.initProgression
            .emit(to: progressBarView.rx.initProgression)
            .disposed(by: disposeBag)
        
        viewModel.output.nowValues
            .drive { [unowned self] makeReviewModel in
                self.tagsView.setTags(makeReviewModel.tags)
                self.moveWithKeyboardView.setText(makeReviewModel.message)
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                self?.updateButtonPostion(keyboardHeight: height)
            })
            .disposed(by: disposeBag)
        
//        RxKeyboard.instance.visibleHeight
//            .map { [weak self] height in
//                return height + (self?.continueButtonView.frame.height ?? 0)
//            }
//            .drive(viewModel.input.keyboardWithButtonHeight)
//            .disposed(by: disposeBag)
    }
}

