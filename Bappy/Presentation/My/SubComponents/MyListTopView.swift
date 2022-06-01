//
//  MyListTopView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/01.
//

import UIKit
import SnapKit

protocol MyListTopViewDelegate: AnyObject {
    func fetchMyHangout()
    func fetchSavedHangout()
}

final class MyListTopView: UIView {
    
    // MARK: Properties
    weak var delegate: MyListTopViewDelegate?
    
    private let searchBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
        backgroundView.layer.cornerRadius = 16.0
        return backgroundView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search your hangout",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!])
        containerView.frame = CGRect(x: 0, y: 0, width: 26.0, height: 12.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        return textField
    }()
    
    private lazy var myHangoutButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "My Hagout",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 16.0, family: .Medium)
                ]),
            for: .normal)
        button.addTarget(self, action: #selector(myHangoutButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var savedHangoutButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Saved Hagout",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_brown")!,
                    .font: UIFont.roboto(size: 16.0, family: .Medium)
                ]),
            for: .normal)
        button.addTarget(self, action: #selector(savedHangoutButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let contentView = UIView()
    private let yellowBarView = UIView()
    private let barBackgroundView = UIView()
    
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
    private func myHangoutButtonHandler() {
        UIView.animate(withDuration: 0.3) {
            self.yellowBarView.snp.removeConstraints()
            self.yellowBarView.snp.makeConstraints {
                $0.top.equalTo(self.barBackgroundView)
                $0.height.equalTo(4.0)
                $0.width.equalToSuperview().dividedBy(2.0)
                $0.leading.equalToSuperview()
            }
            
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func savedHangoutButtonHandler() {
        UIView.animate(withDuration: 0.3) {
            self.yellowBarView.snp.removeConstraints()
            self.yellowBarView.snp.makeConstraints {
                $0.top.equalTo(self.barBackgroundView)
                $0.height.equalTo(4.0)
                $0.width.equalToSuperview().dividedBy(2.0)
                $0.trailing.equalToSuperview()
            }
            
            self.layoutIfNeeded()
        }
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.addBappyShadow(shadowOffsetHeight: 1.0)
        yellowBarView.backgroundColor = UIColor(named: "bappy_yellow")
        barBackgroundView.backgroundColor = UIColor(named: "bappy_lightgray")
    }
    
    private func layout() {
        let hStackView = UIStackView(arrangedSubviews: [myHangoutButton, savedHangoutButton])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 0
        
        self.addSubview(barBackgroundView)
        barBackgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(8.0)
        }
        
        self.addSubview(yellowBarView)
        yellowBarView.snp.makeConstraints {
            $0.top.equalTo(barBackgroundView)
            $0.height.equalTo(4.0)
            $0.width.equalToSuperview().dividedBy(2.0)
            $0.leading.equalToSuperview()
        }
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(barBackgroundView.snp.top)
        }
        
        contentView.addSubview(searchBackgroundView)
        searchBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.leading.equalToSuperview().inset(40.0)
            $0.trailing.equalToSuperview().inset(39.0)
            $0.height.equalTo(32.0)
        }
        
        searchBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView.snp.bottom).offset(7.0)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(39.0)
        }
    }
}
