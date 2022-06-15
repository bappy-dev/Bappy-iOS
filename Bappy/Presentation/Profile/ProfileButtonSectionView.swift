//
//  ProfileButtonSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/11.
//

import UIKit
import SnapKit

final class ProfileButtonSectionView: UIView {
    
    // MARK: Properties
    private lazy var joinedButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(joinedButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var madeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(madeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelledButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelledButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let yellowView = UIView()
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.addBappyShadow()
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
    
    private let cancelledLabel: UILabel = {
        let label = UILabel()
        label.text = "Hangout\ncancelled"
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
    
    private let numOfCancelledLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bappyBrown
        label.font = .roboto(size: 15.0)
        return label
    }()

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Actions
    @objc
    private func joinedButtonHandler() {
        updateYellowBarLayout(index: 0)
    }

    @objc
    private func madeButtonHandler() {
        updateYellowBarLayout(index: 1)
    }

    @objc
    private func cancelledButtonHandler() {
        updateYellowBarLayout(index: 2)
    }

    // MARK: Helpers
    private func updateYellowBarLayout(index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.yellowView.snp.remakeConstraints {
                let inset = self.frame.width * CGFloat(index) / 3.0
                $0.bottom.equalToSuperview()
                $0.height.equalTo(6.0)
                $0.width.equalTo(self.snp.width).dividedBy(3.0)
                $0.leading.equalToSuperview().inset(inset)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func configure() {
        self.backgroundColor = .bappyLightgray
        yellowView.backgroundColor = .bappyYellow
        numOfjoinedLabel.text = "0"
        numOfMadeLabel.text = "0"
        numOfCancelledLabel.text = "0"
    }

    private func layout() {
        hStackView.addArrangedSubview(joinedButton)
        hStackView.addArrangedSubview(madeButton)
        hStackView.addArrangedSubview(cancelledButton)
        
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
            $0.height.equalTo(101.0)
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
        
        cancelledButton.addSubview(cancelledLabel)
        cancelledLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(23.0)
        }
        
        cancelledButton.addSubview(numOfCancelledLabel)
        numOfCancelledLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7.0)
        }
    }
}
