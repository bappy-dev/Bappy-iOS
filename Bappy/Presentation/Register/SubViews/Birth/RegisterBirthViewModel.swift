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
        var date: AnyObserver<String>
    }
    
    struct Output {
        var date: Signal<String>
        var isValid: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
        
    let subViewModels: SubViewModels
    
    private let date$ = PublishSubject<String>()
    
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
            .asSignal(onErrorJustReturn: dependency.date)
        let isValid = date$
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(date: date$.asObserver())
        self.output = Output(date: date, isValid: isValid)
        
        // Binding        
        subViewModel.birthPickerViewModel.output.date
            .emit(to: date$)
            .disposed(by: disposeBag)
    }
}
