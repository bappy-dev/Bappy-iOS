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
        var year: String
        var month: String
        var day: String
        var yearList: [String]
        var monthList: [String]
        var dayList: [String]
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
    
    init(dependency: Dependency) {
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
        
        // Streams
        let date = date$
            .compactMap { $0?.toString(dateFormat: "yyyy-MM-dd") }
            .asSignal(onErrorJustReturn: dependency.date)
        let isValid = date$
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            date: date$.asObserver()
        )
        
        self.output = Output(
            date: date,
            isValid: isValid,
            selectedDate: selectedDate$
        )
        
        // Binding        
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
