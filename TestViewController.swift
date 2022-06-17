//
//  TestViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/17.
//

import UIKit
import SnapKit

final class TestViewController: UIViewController {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .bappyYellow
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        datePicker.minuteInterval = 10
        datePicker.addTarget(self, action: #selector(datePickerEditingChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(datePickerEditingChanged), for: .allEvents)
        return datePicker
    }()
    
    private let selectedDate: UILabel = {
        let label = UILabel()
        label.backgroundColor = .bappyYellow
        label.textColor = .white
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectedDate.layer.cornerRadius = selectedDate.frame.height / 2.0
    }
    
    @objc
    private func datePickerEditingChanged(datePicker: UIDatePicker) {
        print("DEBUG: date \(datePicker.date.toString(dateFormat: "d E"))")
        selectedDate.text = datePicker.date.toString(dateFormat: "d")
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(42.0)
            $0.trailing.equalToSuperview().inset(41.0)
            $0.height.equalTo(datePicker.snp.width).multipliedBy(295.0/292.0)
        }
        
        datePicker.addSubview(selectedDate)
        selectedDate.snp.makeConstraints {
//            $0.center.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100.0)
            $0.width.height.equalTo(datePicker.snp.width).dividedBy(6.5)
        }
    }
}

extension Date {
    enum Day: Int {
        case Sun = 1, Mon, Tue, Wed, Thu, Fri, Sat
    }
    
    static func getRowsAndColumnsFromCalendar(date: Int, day: Date.Day) -> (row: Int, column: Int) {
        let roundedNumber = date / 7 + ( (date % 7 == 0) ? 0 : 1)
        let firstDate = (date % 7 == 0) ? 7 : date % 7
        let alpha = (firstDate > day.rawValue) ? 1 : 0
        return (row: roundedNumber + alpha, column: day.rawValue)
    }
}
