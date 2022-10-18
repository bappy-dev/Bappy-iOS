//
//  ProfileButtonSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileButtonSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: ProfileButtonSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let joinedButton = UIButton()
    private let likedButton = UIButton()
    private let referenceButton = UIButton()
    private let yellowView = UIView()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let joinedImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "open-arm-line")
        image.tintColor = .bappyBrown
        return image
    }()
    
    private let likedImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "heart-line")
        image.tintColor = .bappyBrown
        return image
    }()
    
    private let referenceImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "thumb-up-line")
        image.tintColor = .bappyBrown
        return image
    }()
    
    private let joinedLabel: UILabel = {
        let label = UILabel()
        label.text = "Joined"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let likedLabel: UILabel = {
        let label = UILabel()
        label.text = "Liked"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let referenceLabel: UILabel = {
        let label = UILabel()
        label.text = "Reference"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let numOfjoinedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 15.0)
        return label
    }()
    
    private let numOfLikedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 15.0)
        return label
    }()
    
    private let numOfReferenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 15.0)
        return label
    }()

    // MARK: Lifecycle
    init(viewModel: ProfileButtonSectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }

    // MARK: Helpers
    private func configureShadow() {
        hStackView.addBappyShadow()
    }
    
    private func updateYellowBarLayout(index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.yellowView.snp.updateConstraints {
                let inset = self.frame.width * CGFloat(index) / 3.0
                $0.leading.equalToSuperview().inset(inset)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func configure() {
        self.backgroundColor = .bappyLightgray
        yellowView.backgroundColor = .bappyYellow
    }

    private func layout() {
        hStackView.addArrangedSubview(joinedButton)
        hStackView.addArrangedSubview(likedButton)
        hStackView.addArrangedSubview(referenceButton)
        
        self.snp.makeConstraints {
            $0.height.equalTo(107.0)
        }
        
        self.addSubview(yellowView)
        yellowView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(6.0)
            $0.width.equalTo(self.snp.width).dividedBy(3.0)
            $0.leading.equalToSuperview()
        }
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(yellowView.snp.top)
        }
        
        zip([joinedButton, likedButton, referenceButton],
            [joinedImage, likedImage, referenceImage]).forEach { (button, image) in
            button.addSubview(image)
            image.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(6.0)
                $0.width.height.equalTo(24.0)
            }
        }
        
        zip([joinedButton, likedButton, referenceButton],
            [joinedLabel, likedLabel, referenceLabel]).forEach { (button, label) in
            button.addSubview(label)
            label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(34.0)
            }
        }
        
        zip([joinedButton, likedButton, referenceButton],
            [numOfjoinedLabel, numOfLikedLabel, numOfReferenceLabel]).forEach { (button, label) in
            button.addSubview(label)
            label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(20.0)
            }
        }
    }
}

// MARK: - Bind
extension ProfileButtonSectionView {
    private func bind() {
        joinedButton.rx.tap
            .bind(to: viewModel.input.joinedButtonTapped)
            .disposed(by: disposeBag)
        
        likedButton.rx.tap
            .bind(to: viewModel.input.madeButtonTapped)
            .disposed(by: disposeBag)
        
        referenceButton.rx.tap
            .bind(to: viewModel.input.likedButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.numOfJoinedHangouts
            .drive(numOfjoinedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.numOfLikedHangouts
            .drive(numOfLikedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.numOfReferenceHangouts
            .drive(numOfReferenceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.selectedIndex
            .emit(onNext: { [weak self] index in
                self?.updateYellowBarLayout(index: index)
            })
            .disposed(by: disposeBag)
    }
}
