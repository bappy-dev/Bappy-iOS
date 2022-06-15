//
//  BappyCalendarView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit

final class BappyCalendarView: UIView {
    
    // MARK: Properties
    var date: Date { return datePicker.date }
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .bappyYellow
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 10
        datePicker.minimumDate = (Date() + 60 * 60).roundUpUnitDigitOfMinutes()
        return datePicker
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
        self.clipsToBounds = true
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = .bappyYellow
        
        self.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalTo(dividingView.snp.bottom).offset(5.5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(datePicker.snp.width).multipliedBy(295.0/292.0)
        }
    }
}
