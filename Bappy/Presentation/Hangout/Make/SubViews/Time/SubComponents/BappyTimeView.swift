//
//  BappyTimeView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit

final class BappyTimeView: UIView {
    
    //MARK: Properties
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = UIColor(named: "bappy_yellow")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 10
        datePicker.setValue(UIColor(named: "bappy_brown"), forKey: "textColor")
        datePicker.subviews[0].subviews[1].backgroundColor = .clear
//        datePicker.minimumDate = Date() + 60 * 10
//        datePicker.addTarget(self, action: #selector(DidChangeDatePicker), for: .valueChanged)
        return datePicker
    }()
   
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("DEBUG: datePickerWidth \(datePicker.frame.width)")
        print("DEBUG: datePickerHeight \(datePicker.frame.height)")
    }

    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        self.clipsToBounds = true
    }

    private func layout() {
        let selectView = UIView()
        selectView.layer.cornerRadius = 18.0
        selectView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        
        self.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.height.equalTo(36.0)
            $0.leading.equalToSuperview().inset(15.0)
            $0.trailing.equalToSuperview().inset(7.0)
        }
        
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.centerY.equalTo(selectView)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(datePicker.snp.width).multipliedBy(216.0/292.0)
        }
    }
}
