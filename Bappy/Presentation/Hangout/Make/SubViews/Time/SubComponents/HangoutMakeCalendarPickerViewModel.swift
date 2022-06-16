//
//  HangoutMakeCalendarPickerViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeCalendarPickerViewModel: ViewModelType {

    struct Dependency {
        var minimumDate: Date
    }
    
    struct Input {
        var date: AnyObserver<Date> // <-> View
        var doneButtonTapped: AnyObserver<Void> // <-> Parent
        var initialized: AnyObserver<Void> // <-> Parent
    }
    
    struct Output {
        var minimumDate: Driver<Date> // <-> View
        var initDate: Driver<Date> // <-> View
        var calendarDate: Driver<Date> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let minimumDate$: BehaviorSubject<Date>
    private let date$: BehaviorSubject<Date>
    private let doneButtonTapped$ = PublishSubject<Void>()
    private let initialized$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let minimumDate$ = BehaviorSubject<Date>(value: dependency.minimumDate)
        let date$ = BehaviorSubject<Date>(value: dependency.minimumDate)
        
        let minimumDate = minimumDate$
            .asDriver(onErrorJustReturn: dependency.minimumDate)
        let initDate = initialized$
            .withLatestFrom(minimumDate$)
            .asDriver(onErrorJustReturn: dependency.minimumDate)
        let calendarDate = doneButtonTapped$
            .withLatestFrom(date$)
            .withLatestFrom(minimumDate$, resultSelector: getCalendarDate)
            .asDriver(onErrorJustReturn: dependency.minimumDate)
            
        // Input & Output
        self.input = Input(
            date: date$.asObserver(),
            doneButtonTapped: doneButtonTapped$.asObserver(),
            initialized: initialized$.asObserver()
        )
        
        self.output = Output(
            minimumDate: minimumDate,
            initDate: initDate,
            calendarDate: calendarDate
        )
        
        // Binding
        self.minimumDate$ = minimumDate$
        self.date$ = date$
        
        initDate
            .drive(date$)
            .disposed(by: disposeBag)
    }
}

private func getCalendarDate(date: Date, minimumDate: Date) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let day = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "HH:mm:ss"
    let time = dateFormatter.string(from: minimumDate)
    let dayAndTime = "\(day) \(time)"
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.date(from: dayAndTime) ?? date
}
