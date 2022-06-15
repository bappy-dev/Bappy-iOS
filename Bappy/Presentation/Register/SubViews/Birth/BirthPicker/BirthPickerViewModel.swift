//
//  BirthPickerViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/14.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthPickerViewModel: ViewModelType {
    struct Dependency {
        var year: String
        var month: String
        var day: String
        var yearList: [String]
        var monthList: [String]
        var dayList: [String]
        var yearRow: Int { yearList.firstIndex(of: year) ?? 0 }
        var monthRow: Int { monthList.firstIndex(of: month) ?? 0 }
        var dayRow: Int { dayList.firstIndex(of: day) ?? 0 }
    }
    
    struct Input {
        var year: AnyObserver<String>
        var month: AnyObserver<String>
        var day: AnyObserver<String>
        var yearList: AnyObserver<[String]> // 고정값
        var monthList: AnyObserver<[String]> // 고정값
        var dayList: AnyObserver<[String]> // 고정값
        // View -> ViewModel
        var selectedYearRow: AnyObserver<Int>
        var selectedMonthRow: AnyObserver<Int>
        var selectedDayRow: AnyObserver<Int>
        var doneButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var date: Signal<String>
        // ViewModel -> View
        var yearList: Driver<[String]> // 고정값
        var monthList: Driver<[String]> // 고정값
        var dayList: Driver<[String]> // 고정값
        var yearRow: BehaviorRelay<(row: Int, component: Int)>
        var monthRow: BehaviorRelay<(row: Int, component: Int)>
        var dayRow: BehaviorRelay<(row: Int, component: Int)>
        var shouldHide: Signal<Void>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let year$: BehaviorSubject<String>
    private let month$: BehaviorSubject<String>
    private let day$: BehaviorSubject<String>
    private let yearList$: BehaviorSubject<[String]>
    private let monthList$: BehaviorSubject<[String]>
    private let dayList$: BehaviorSubject<[String]>
    private let selectedYearRow$: BehaviorSubject<Int>
    private let selectedMonthRow$: BehaviorSubject<Int>
    private let selectedDayRow$: BehaviorSubject<Int>
    private let doneButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let year$ = BehaviorSubject<String>(value: dependency.year)
        let month$ = BehaviorSubject<String>(value: dependency.month)
        let day$ = BehaviorSubject<String>(value: dependency.day)
        let yearList$ = BehaviorSubject<[String]>(value: dependency.yearList)
        let monthList$ = BehaviorSubject<[String]>(value: dependency.monthList)
        let dayList$ = BehaviorSubject<[String]>(value: dependency.dayList)
        let selectedYearRow$ = BehaviorSubject<Int>(value: dependency.yearRow)
        let selectedMonthRow$ = BehaviorSubject<Int>(value: dependency.monthRow)
        let selectedDayRow$ = BehaviorSubject<Int>(value: dependency.dayRow)
        
        let date = doneButtonTapped$
            .withLatestFrom(Observable.combineLatest(year$, month$, day$))
            .map { "\($0)-\($1)-\($2)" }
            .asSignal(onErrorJustReturn: "\(dependency.year)-\(dependency.month)-\(dependency.day)")
        
        let selectedDate = Observable
            .combineLatest(
                selectedYearRow$.withLatestFrom(yearList$, resultSelector: { $1[$0] }),
                selectedMonthRow$.withLatestFrom(monthList$, resultSelector: { $1[$0] }),
                selectedDayRow$.withLatestFrom(dayList$, resultSelector: { $1[$0] })
            )
            .share()
        let yearList = yearList$
            .asDriver(onErrorJustReturn: [])
        let monthList = monthList$
            .asDriver(onErrorJustReturn: [])
        let dayList = dayList$
            .asDriver(onErrorJustReturn: [])
        let yearRow = BehaviorRelay<(row: Int, component: Int)>(value: (row: dependency.yearRow, component: 0))
        let monthRow = BehaviorRelay<(row: Int, component: Int)>(value: (row: dependency.monthRow, component: 0))
        let dayRow = BehaviorRelay<(row: Int, component: Int)>(value: (row: dependency.dayRow, component: 0))
        let shouldHide = doneButtonTapped$
            .asSignal(onErrorJustReturn: Void())

        // Input & Output
        self.input = Input(
            year: year$.asObserver(),
            month: month$.asObserver(),
            day: day$.asObserver(),
            yearList: yearList$.asObserver(),
            monthList: monthList$.asObserver(),
            dayList: dayList$.asObserver(),
            selectedYearRow: selectedYearRow$.asObserver(),
            selectedMonthRow: selectedMonthRow$.asObserver(),
            selectedDayRow: selectedDayRow$.asObserver(),
            doneButtonTapped: doneButtonTapped$.asObserver()
        )
        
        self.output = Output(
            date: date,
            yearList: yearList,
            monthList: monthList,
            dayList: dayList,
            yearRow: yearRow,
            monthRow: monthRow,
            dayRow: dayRow,
            shouldHide: shouldHide
        )
        
        // Binding
        self.year$ = year$
        self.month$ = month$
        self.day$ = day$
        self.yearList$ = yearList$
        self.monthList$ = monthList$
        self.dayList$ = dayList$
        self.selectedYearRow$ = selectedYearRow$
        self.selectedMonthRow$ = selectedMonthRow$
        self.selectedDayRow$ = selectedDayRow$
        
        selectedDate
            .filter(isValidDateForm)
            .map { $0.0 }
            .bind(to: year$)
            .disposed(by: disposeBag)
        
        selectedDate
            .filter(isValidDateForm)
            .map { $0.1 }
            .bind(to: month$)
            .disposed(by: disposeBag)
        
        selectedDate
            .filter(isValidDateForm)
            .map { $0.2 }
            .bind(to: day$)
            .disposed(by: disposeBag)
        
        selectedDate
            .filter { !isValidDateForm(date: (year: $0.0, month: $0.1, day: $0.2)) }
            .withLatestFrom(Observable.combineLatest(yearList$, year$))
            .map { $0.0.firstIndex(of: $0.1) ?? 0 }
            .map { (row: $0, component: 0) }
            .bind(to: yearRow)
            .disposed(by: disposeBag)
        
        selectedDate
            .filter { !isValidDateForm(date: (year: $0.0, month: $0.1, day: $0.2)) }
            .withLatestFrom(Observable.combineLatest(monthList$, month$))
            .map { $0.0.firstIndex(of: $0.1) ?? 0 }
            .map { (row: $0, component: 0) }
            .bind(to: monthRow)
            .disposed(by: disposeBag)
        
        selectedDate
            .filter { !isValidDateForm(date: (year: $0.0, month: $0.1, day: $0.2)) }
            .withLatestFrom(Observable.combineLatest(dayList$, day$))
            .map { $0.0.firstIndex(of: $0.1) ?? 0 }
            .map { (row: $0, component: 0) }
            .bind(to: dayRow)
            .disposed(by: disposeBag)
    }
}

private func isValidDateForm(date: (year: String, month: String, day: String)) -> Bool {
    let date = "\(date.year)-\(date.month)-\(date.day)"
    return date.isValidDateType(format: "yyyy-MM-dd")
}
