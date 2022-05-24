//
//  HangoutMainSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import SwiftUI

final class HangoutMainSectionView: UIView {
    
    // MARK: Properties
    private let hostCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.text = "Host"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "no_profile_s")
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameAndFlagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Jessica  🇺🇸"
        label.font = .roboto(size: 13.0)
        return label
    }()
    
    private let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "report"), for: .normal)
        button.imageEdgeInsets = .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        return button
    }()
    
    private let titleCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.text = "Title"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let timeCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.text = "Time"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let placeCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.text = "Place"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let languageCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 14.0, family: .Medium)
        label.text = "Language"
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 12.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.text = "#Korean #Restaurant #PNU #Yummy "
        return textField
    }()

    
    private let timeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 12.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.text = "03. Mar. 19:00"
        return textField
    }()
    
    private let placeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 12.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.text = "PNU maingate"
        return textField
    }()
    
    private let languageTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 12.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.text = "English"
        return textField
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
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        let dividingView1 = UIView()
        let dividingView2 = UIView()
        let dividingView3 = UIView()
        let dividingView4 = UIView()
        [dividingView1, dividingView2, dividingView3, dividingView4].forEach { dividingView in
            dividingView.backgroundColor = UIColor(named: "bappy_brown")
        }
        
        self.addSubview(hostCaptionLabel)
        hostCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3.0)
            $0.leading.equalToSuperview().inset(28.0)
        }
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(hostCaptionLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(hostCaptionLabel)
        }
        
        self.addSubview(nameAndFlagLabel)
        nameAndFlagLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView).offset(2.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(14.0)
        }
        
        self.addSubview(reportButton)
        reportButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(21.0)
            $0.width.height.equalTo(44.0)
        }
        
        self.addSubview(titleCaptionLabel)
        titleCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(33.0)
            $0.leading.equalTo(profileImageView)
        }
        
        self.addSubview(timeCaptionLabel)
        timeCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleCaptionLabel.snp.bottom).offset(26.0)
            $0.leading.equalTo(profileImageView)
        }
        
        self.addSubview(placeCaptionLabel)
        placeCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(timeCaptionLabel.snp.bottom).offset(26.0)
            $0.leading.equalTo(profileImageView)
        }
        
        self.addSubview(languageCaptionLabel)
        languageCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(placeCaptionLabel.snp.bottom).offset(26.0)
            $0.leading.equalTo(profileImageView)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        self.addSubview(dividingView1)
        dividingView1.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.height.equalTo(15.5)
            $0.centerY.equalTo(titleCaptionLabel)
            $0.leading.equalTo(titleCaptionLabel.snp.trailing).offset(46.8)
        }
        
        self.addSubview(dividingView2)
        dividingView2.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.height.equalTo(15.5)
            $0.centerY.equalTo(timeCaptionLabel)
            $0.centerX.equalTo(dividingView1)
        }
        
        self.addSubview(dividingView3)
        dividingView3.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.height.equalTo(15.5)
            $0.centerY.equalTo(placeCaptionLabel)
            $0.centerX.equalTo(dividingView1)
        }
        
        self.addSubview(dividingView4)
        dividingView4.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.height.equalTo(15.5)
            $0.centerY.equalTo(languageCaptionLabel)
            $0.centerX.equalTo(dividingView1)
        }
        
        self.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.centerY.equalTo(titleCaptionLabel)
            $0.leading.equalTo(dividingView1.snp.trailing).offset(22.8)
            $0.trailing.lessThanOrEqualToSuperview().inset(14.0)
        }
        
        self.addSubview(timeTextField)
        timeTextField.snp.makeConstraints {
            $0.centerY.equalTo(timeCaptionLabel)
            $0.leading.equalTo(dividingView2.snp.trailing).offset(22.8)
            $0.trailing.lessThanOrEqualToSuperview().inset(14.0)
        }
        
        self.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.centerY.equalTo(placeCaptionLabel)
            $0.leading.equalTo(dividingView3.snp.trailing).offset(22.8)
            $0.trailing.lessThanOrEqualToSuperview().inset(14.0)
        }
        
        self.addSubview(languageTextField)
        languageTextField.snp.makeConstraints {
            $0.centerY.equalTo(languageCaptionLabel)
            $0.leading.equalTo(dividingView4.snp.trailing).offset(22.8)
            $0.trailing.lessThanOrEqualToSuperview().inset(14.0)
        }
    }
}
