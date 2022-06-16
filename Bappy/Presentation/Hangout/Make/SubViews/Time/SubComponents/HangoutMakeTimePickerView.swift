//
//  HangoutMakeTimePickerView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeTimePickerView: UIView {
    
    //MARK: Properties
    private let viewModel: HangoutMakeTimePickerViewModel
    private let disposBag = DisposeBag()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .bappyYellow
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        datePicker.minuteInterval = 10
        datePicker.setValue(UIColor.bappyBrown, forKey: "textColor")
        datePicker.subviews[0].subviews[1].backgroundColor = .clear
        return datePicker
    }()
   
    // MARK: Lifecycle
    init(viewModel: HangoutMakeTimePickerViewModel) {
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

// MARK: Bind
extension HangoutMakeTimePickerView {
    private func bind() {
        datePicker.rx.date
//            .skip(1)
            .bind(to: viewModel.input.date)
            .disposed(by: disposBag)
        
        datePicker.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.editingDidBegin)
            .disposed(by: disposBag)
        
        viewModel.output.minimumDate
            .drive(datePicker.rx.minimumDate)
            .disposed(by: disposBag)
        
        viewModel.output.initDate
            .drive(datePicker.rx.date)
            .disposed(by: disposBag)
        
        viewModel.output.dismissKeyboard
            .emit(to: datePicker.rx.resignFirstResponder)
            .disposed(by: disposBag)
        
        viewModel.output.calendarDate
            .emit(to: datePicker.rx.date)
            .disposed(by: disposBag)
    }
}
