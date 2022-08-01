//
//  HangoutMakeTimePickerViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeTimePickerViewModel: ViewModelType {
    
    struct Dependency {
        var minimumDate: Date
    }
    
    struct Input {
        var date: AnyObserver<Date> // <-> View
        var editingDidBegin: AnyObserver<Void> // <-> View
        var calendarDate: AnyObserver<Date?> // <-> Parent
        var doneButtonTapped: AnyObserver<Void> // <-> Parent
        var initialized: AnyObserver<Date> // <-> Parent
    }
    
    struct Output {
        var minimumDate: Driver<Date> // <-> View
        var initDate: Driver<Date> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var calendarDate: Signal<Date> // <-> View
        var timeDate: Driver<Date?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let minimumDate$: BehaviorSubject<Date>
    private let date$: BehaviorSubject<Date>
    private let editingDidBegin$ = PublishSubject<Void>()
    private let calendarDate$: BehaviorSubject<Date?>
    private let doneButtonTapped$ = PublishSubject<Void>()
    private let initialized$: BehaviorSubject<Date>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let minimumDate$ = BehaviorSubject<Date>(value: dependency.minimumDate)
        let date$ = BehaviorSubject<Date>(value: dependency.minimumDate)
        let calendarDate$ = BehaviorSubject<Date?>(value: nil)
        let initialized$ = BehaviorSubject<Date>(value: dependency.minimumDate)
        
        let minimumDate = minimumDate$
            .asDriver(onErrorJustReturn: dependency.minimumDate)
        let initDate = initialized$
            .asDriver(onErrorJustReturn: dependency.minimumDate)
        let dismissKeyboard = editingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let calendarDate = calendarDate$
            .map { $0 ?? dependency.minimumDate }
            .asSignal(onErrorJustReturn: dependency.minimumDate)
        let timeDate = Observable<Date?>
            .merge(
                doneButtonTapped$.withLatestFrom(date$) { $1 },
                initialized$.map { _ -> Date? in nil }
            )
            .asDriver(onErrorJustReturn: nil)
            
        // MARK: Input & Output
        self.input = Input(
            date: date$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            calendarDate: calendarDate$.asObserver(),
            doneButtonTapped: doneButtonTapped$.asObserver(),
            initialized: initialized$.asObserver()
        )
        
        self.output = Output(
            minimumDate: minimumDate,
            initDate: initDate,
            dismissKeyboard: dismissKeyboard,
            calendarDate: calendarDate,
            timeDate: timeDate
        )
        
        // MARK: Binding
        self.minimumDate$ = minimumDate$
        self.date$ = date$
        self.calendarDate$ = calendarDate$
        self.initialized$ = initialized$
        
        calendarDate
            .emit(to: date$)
            .disposed(by: disposeBag)
        
        initDate
            .drive(date$)
            .disposed(by: disposeBag)
    }
}
