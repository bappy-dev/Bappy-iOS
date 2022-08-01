//
//  RegisterBirthViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterBirthViewModel: ViewModelType {
    
    struct SubViewModels {
        let birthPickerViewModel: BirthPickerViewModel
    }
    
    struct Dependency {
        var year: String { "2000" }
        var month: String { "06" }
        var day: String { "15" }
        var yearList: [String] {
            Array(1931...Date.thisYear-17)
                .map { String($0) }
        }
        var monthList: [String] {
            Array(1...12)
                .map { String($0) }
                .map { ($0.count == 1) ? "0\($0)" : $0 }
        }
        var dayList: [String] {
            Array(1...31)
                .map { String($0) }
                .map { ($0.count == 1) ? "0\($0)" : $0 }
        }
        var date: String { "\(year)-\(month)-\(day)" }
    }
    
    struct Input {
        var date: AnyObserver<Date?> // <-> Child(Picker)
    }
    
    struct Output {
        var date: Signal<String> // <-> View
        var isValid: Driver<Bool> // <-> Parent
        var selectedDate: PublishSubject<Date> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
        
    let subViewModels: SubViewModels
    
    private let date$ = PublishSubject<Date?>()
    
    private let selectedDate$ = PublishSubject<Date>()
    
    init(dependency: Dependency = Dependency()) {
        let subViewModel = SubViewModels(
            birthPickerViewModel: BirthPickerViewModel(
                dependency: .init(
                    year: dependency.year,
                    month: dependency.month,
                    day: dependency.day,
                    yearList: dependency.yearList,
                    monthList: dependency.monthList,
                    dayList: dependency.dayList)
            )
        )
        
        self.dependency = dependency
        self.subViewModels = subViewModel
        
        // MARK: Streams
        let date = date$
            .compactMap { $0?.toString(dateFormat: "yyyy-MM-dd") }
            .asSignal(onErrorJustReturn: dependency.date)
        let isValid = date$
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            date: date$.asObserver()
        )
        
        self.output = Output(
            date: date,
            isValid: isValid,
            selectedDate: selectedDate$
        )
        
        // MARK: Binding        
        subViewModel.birthPickerViewModel.output.date
            .compactMap { $0 }
            .emit(to: date$)
            .disposed(by: disposeBag)
        
        subViewModel.birthPickerViewModel.output.date
            .compactMap { $0 }
            .emit(to: selectedDate$)
            .disposed(by: disposeBag)
    }
}
