//
//  HangoutPlaceView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit

protocol HangoutPlaceViewDelegate: AnyObject {
    func showSearchPlaceView()
}

final class HangoutPlaceView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutPlaceViewDelegate?
    
    private let placeCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Write the place\nto meet"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "place"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the place",
            attributes: [.foregroundColor: UIColor(named: "bappy_gray")!,
                         .font: UIFont.roboto(size: 16.0)
                        ])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 18.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(placeTextFieldHandler), for: .editingDidBegin)
        return textField
    }()
    
    private let underlinedView: UIView = {
        let underlinedView = UIView()
        underlinedView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        underlinedView.addBappyShadow(shadowOffsetHeight: 1.0)
        return underlinedView
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
    private func placeTextFieldHandler(_ textField: UITextField) {
        delegate?.showSearchPlaceView()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(placeCaptionLabel)
        placeCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeCaptionLabel.snp.bottom).offset(96.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }
        
        self.addSubview(underlinedView)
        underlinedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44.0)
            $0.height.equalTo(2.0)
            $0.top.equalTo(placeTextField.snp.bottom).offset(7.0)
        }
    }
}
