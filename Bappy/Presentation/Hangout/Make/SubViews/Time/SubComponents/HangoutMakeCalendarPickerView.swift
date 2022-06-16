//
//  HangoutMakeCalendarPickerView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeCalendarPickerView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeCalendarPickerViewModel
    private let disposBag = DisposeBag()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .bappyYellow
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        datePicker.minuteInterval = 10
        return datePicker
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakeCalendarPickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
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

// MARK: - Bind
extension HangoutMakeCalendarPickerView {
    private func bind() {
        datePicker.rx.date
            .bind(to: viewModel.input.date)
            .disposed(by: disposBag)
        
        viewModel.output.minimumDate
            .drive(datePicker.rx.minimumDate)
            .disposed(by: disposBag)
        
        viewModel.output.initDate
            .drive(datePicker.rx.date)
            .disposed(by: disposBag)
    }
}
