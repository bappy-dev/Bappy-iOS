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
    private let madeButton = UIButton()
    private let likedButton = UIButton()
    private let yellowView = UIView()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let joinedLabel: UILabel = {
        let label = UILabel()
        label.text = "Hangout\njoined"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let madeLabel: UILabel = {
        let label = UILabel()
        label.text = "Hangout\nmade"
        label.textColor = .bappyBrown
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let likedLabel: UILabel = {
        let label = UILabel()
        label.text = "Hangout\nliked"
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
    
    private let numOfMadeLabel: UILabel = {
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
        hStackView.addArrangedSubview(madeButton)
        hStackView.addArrangedSubview(likedButton)
        
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
        
        joinedButton.addSubview(joinedLabel)
        joinedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(23.0)
        }
        
        joinedButton.addSubview(numOfjoinedLabel)
        numOfjoinedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7.0)
        }
        
        madeButton.addSubview(madeLabel)
        madeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(23.0)
        }
        
        madeButton.addSubview(numOfMadeLabel)
        numOfMadeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7.0)
        }
        
        likedButton.addSubview(likedLabel)
        likedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(23.0)
        }
        
        likedButton.addSubview(numOfLikedLabel)
        numOfLikedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7.0)
        }
    }
}

// MARK: - Bind
extension ProfileButtonSectionView {
    private func bind() {
        joinedButton.rx.tap
            .bind(to: viewModel.input.joinedButtonTapped)
            .disposed(by: disposeBag)
        
        madeButton.rx.tap
            .bind(to: viewModel.input.madeButtonTapped)
            .disposed(by: disposeBag)
        
        likedButton.rx.tap
            .bind(to: viewModel.input.likedButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.numOfJoinedHangouts
            .drive(numOfjoinedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.numOfMadeHangouts
            .drive(numOfMadeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.numOfLikedHangouts
            .drive(numOfLikedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.selectedIndex
            .emit(onNext: { [weak self] index in
                self?.updateYellowBarLayout(index: index)
            })
            .disposed(by: disposeBag)
    }
}
