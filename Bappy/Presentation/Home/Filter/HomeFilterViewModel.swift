//
//  FilterViewModel.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/09.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeFilterViewModel: ViewModelType {
    var dependency: Dependency
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    struct SubViewModels {
        let calendarViewModel: HangoutMakeCategoryViewModel
    }
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(calendarViewModel: HangoutMakeCategoryViewModel())
                                            //HangoutMakeCalendarPickerViewModel(dependency: .init(minimumDate: dependency.minimumDate)))
        self.input = Input()
        self.output = Output()
    }
    
    struct Dependency {
            var minimumDate: Date {
                (Date() + 60 * 60).roundUpUnitDigitOfMinutes()
            }
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    
}
