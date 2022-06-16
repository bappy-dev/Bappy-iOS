//
//  HangoutMakeTimeViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeTimeViewModel: ViewModelType {
    
    struct SubViewModels {
        let calendarPickerViewModel: HangoutMakeCalendarPickerViewModel
        let timePickerViewModel: HangoutMakeTimePickerViewModel
    }
    
    struct Dependency {
        var minimumDate: Date
        var dateFormat: String
        var timeFormat: String
        var calendarText: String {
            minimumDate.toString(dateFormat: dateFormat)
        }
        var timeText: String {
            let text = minimumDate.toString(dateFormat: timeFormat)
            return addDotAtTimeText(timeText: text)
        }
    }
    
    struct Input {
        var dateEditingDidBegin: AnyObserver<Void> // <-> View
        var timeEditingDidBegin: AnyObserver<Void> // <-> View
        var dateDoneButtonTapped: AnyObserver<Void> // <-> View
        var timeDoneButtonTapped: AnyObserver<Void> // <-> View
        var calendarDate: AnyObserver<Date?> // <-> Child(Calendar)
        var timeDate: AnyObserver<Date?> // <-> Child(Time)
    }
    
    struct Output {
        var dateDoneButtonTapped: Signal<Void> // <-> View, Child(Calendar)
        var timeDoneButtonTapped: Signal<Void> // <-> View, Child(Time)
        var dismissKeyboardFromDate: Signal<Void> // <-> View
        var dismissKeyboardFormTime: Signal<Void> // <-> View
        var shouldShowDateView: Driver<Bool> // <-> View
        var shouldShowTimeView: Driver<Bool> // <-> View
        var initCalendarDate: Driver<String> // <-> View, Child(Calendar)
        var initTimeDate: Driver<String> // <-> View, Child(Time)
        var calendarDate: Driver<Date?> // <-> Child(Time)
        var date: Driver<Date?> // <-> Parent
        var calendarText: Driver<String> // <-> View
        var timeText: Driver<String> // <-> View
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let shouldShowDateView$ = BehaviorSubject<Bool>(value: false)
    private let shouldShowTimeView$ = BehaviorSubject<Bool>(value: false)
    private let dateEditingDidBegin$ = PublishSubject<Void>()
    private let timeEditingDidBegin$ = PublishSubject<Void>()
    private let dateDoneButtonTapped$ = PublishSubject<Void>()
    private let timeDoneButtonTapped$ = PublishSubject<Void>()
    private let calendarDate$ = BehaviorSubject<Date?>(value: nil)
    private let timeDate$ = BehaviorSubject<Date?>(value: nil)
    private let calendarText$: BehaviorSubject<String>
    private let timeText$: BehaviorSubject<String>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            calendarPickerViewModel: HangoutMakeCalendarPickerViewModel(
                dependency: .init(minimumDate: dependency.minimumDate)
            ),
            timePickerViewModel: HangoutMakeTimePickerViewModel(
                dependency: .init(minimumDate: dependency.minimumDate)
            )
        )
        
        // Streams
        let dateDoneButtonTapped = dateDoneButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let timeDoneButtonTapped = timeDoneButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let dismissKeyboardFromDate = dateEditingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let dismissKeyboardFromTime = timeEditingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let calendarText$ = BehaviorSubject<String>(value: dependency.calendarText)
        let timeText$ = BehaviorSubject<String>(value: dependency.timeText)
        
        let shouldShowDateView = shouldShowDateView$
            .asDriver(onErrorJustReturn: false)
        let shouldShowTimeView = shouldShowTimeView$
            .asDriver(onErrorJustReturn: false)
        let initCalendarDate = dateEditingDidBegin$
            .withLatestFrom(calendarText$)
            .asDriver(onErrorJustReturn: dependency.calendarText)
            .startWith(dependency.calendarText)
        let initTimeDate = Observable
            .merge(dateEditingDidBegin$, timeEditingDidBegin$)
            .withLatestFrom(timeText$)
            .asDriver(onErrorJustReturn: dependency.timeText)
            .startWith(dependency.timeText)
        let calendarDate = calendarDate$
            .asDriver(onErrorJustReturn: nil)
        let date = timeDate$
            .asDriver(onErrorJustReturn: nil)
        let calendarText = calendarText$
            .asDriver(onErrorJustReturn: dependency.calendarText)
        let timeText = timeText$
            .asDriver(onErrorJustReturn: dependency.timeText)
        let isValid = timeDate$
            .map { $0 != nil }
            .asSignal(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            dateEditingDidBegin: dateEditingDidBegin$.asObserver(),
            timeEditingDidBegin: timeEditingDidBegin$.asObserver(),
            dateDoneButtonTapped: dateDoneButtonTapped$.asObserver(),
            timeDoneButtonTapped: timeDoneButtonTapped$.asObserver(),
            calendarDate: calendarDate$.asObserver(),
            timeDate: timeDate$.asObserver()
        )
        
        self.output = Output(
            dateDoneButtonTapped: dateDoneButtonTapped,
            timeDoneButtonTapped: timeDoneButtonTapped,
            dismissKeyboardFromDate: dismissKeyboardFromDate,
            dismissKeyboardFormTime: dismissKeyboardFromTime,
            shouldShowDateView: shouldShowDateView,
            shouldShowTimeView: shouldShowTimeView,
            initCalendarDate: initCalendarDate,
            initTimeDate: initTimeDate,
            calendarDate: calendarDate,
            date: date,
            calendarText: calendarText,
            timeText: timeText,
            isValid: isValid
        )
        
        // Binding
        self.calendarText$ = calendarText$
        self.timeText$ = timeText$
        
        calendarDate
            .map { date -> String in
                if let date = date {
                    return date.toString(dateFormat: dependency.dateFormat)
                } else { return dependency.calendarText }
            }
            .drive(calendarText$)
            .disposed(by: disposeBag)
        
        date
            .map { date -> String in
                if let date = date {
                    let text = date.toString(dateFormat: dependency.timeFormat)
                    return addDotAtTimeText(timeText: text)
                } else { return dependency.timeText }
            }
            .drive(timeText$)
            .disposed(by: disposeBag)
        
        shouldShowDateView
            .filter { $0 }
            .map { _ -> Date? in nil }
            .drive(calendarDate$)
            .disposed(by: disposeBag)
        
        shouldShowDateView
            .filter { $0 }
            .map { _ -> Date? in nil }
            .drive(timeDate$)
            .disposed(by: disposeBag)
        
        
        shouldShowTimeView
            .filter{ $0 }
            .map { _ -> Date? in nil }
            .drive(timeDate$)
            .disposed(by: disposeBag)
        
        dateDoneButtonTapped$.map { _ in false }
            .bind(to: shouldShowDateView$)
            .disposed(by: disposeBag)
        
        dateEditingDidBegin$.map { _ in true }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(to: shouldShowDateView$)
            .disposed(by: disposeBag)
        
        dateEditingDidBegin$.map { _ in false }
            .bind(to: shouldShowTimeView$)
            .disposed(by: disposeBag)
        
        dateDoneButtonTapped$.map { _ in true }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(to: shouldShowTimeView$)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                timeEditingDidBegin$
                    .withLatestFrom(calendarDate$)
                    .filter { $0 != nil }
                    .map { _ in true }, // calendarDate (O)
                timeDoneButtonTapped$.map { _ in false }
            )
            .bind(to: shouldShowTimeView$)
            .disposed(by: disposeBag)
        
        // Child(Calendar)
        dateDoneButtonTapped
            .emit(to: subViewModels.calendarPickerViewModel.input.doneButtonTapped)
            .disposed(by: disposeBag)
        
        initCalendarDate
            .map { _ in }
            .drive(subViewModels.calendarPickerViewModel.input.initialized)
            .disposed(by: disposeBag)
        
        
        subViewModels.calendarPickerViewModel.output.calendarDate
            .drive(calendarDate$)
            .disposed(by: disposeBag)
        
        // Child(Time)
        calendarDate
            .drive(subViewModels.timePickerViewModel.input.calendarDate)
            .disposed(by: disposeBag)
        
        timeDoneButtonTapped
            .emit(to: subViewModels.timePickerViewModel.input.doneButtonTapped)
            .disposed(by: disposeBag)
        
        initTimeDate
            .map { _ in }
            .drive(subViewModels.timePickerViewModel.input.initialized)
            .disposed(by: disposeBag)
        
        subViewModels.timePickerViewModel.output.timeDate
            .drive(timeDate$)
            .disposed(by: disposeBag)
    }
}

private func addDotAtTimeText(timeText: String) -> String {
    var text = timeText
    let startIndex = text.startIndex
    text.insert(".", at: text.index(startIndex, offsetBy: 1))
    text.insert(".", at: text.index(startIndex, offsetBy: 3))
    _ = text.removeLast()
    text.append("0")
    return text
}
