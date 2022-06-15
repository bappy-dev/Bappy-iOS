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
    var date: Date? {
        didSet {
            guard let date = date else { return }
            datePicker.minimumDate = date.isSameDate(with: Date()) ? (Date() + 60 * 60).roundUpUnitDigitOfMinutes() : nil
        }
    }
    
    var selectedTime: String {
        var time = datePicker.date.toString(dateFormat: "a h:mm")
        let startIndex = time.startIndex
        time.insert(".", at: time.index(startIndex, offsetBy: 1))
        time.insert(".", at: time.index(startIndex, offsetBy: 3))
        _ = time.removeLast()
        time.append("0")
        return time
    }
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .bappyYellow
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        datePicker.minuteInterval = 10
        datePicker.setValue(UIColor.bappyBrown, forKey: "textColor")
        datePicker.subviews[0].subviews[1].backgroundColor = .clear
        datePicker.addTarget(self, action: #selector(datePickerDidBeginEdting), for: .editingDidBegin)
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
    
    // MARK: Actions
    @objc
    private func datePickerDidBeginEdting(_ datePicker: UIDatePicker) {
        datePicker.resignFirstResponder()
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
