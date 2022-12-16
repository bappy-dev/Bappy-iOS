//
//  HangoutMakeCategoryViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeCategoryViewModel: ViewModelType {
    
    struct Dependency {
        let isStartWith: Bool = false
        var categories: [Hangout.Category] = []
    }
    
    struct Input { }
    
    struct Output {
        var categories: Signal<[Hangout.Category]> // <-> Parent
        var shouldHideRule: Driver<Bool> // <-> View
        var isValid: Driver<Bool> // <-> Parent
    }
    
    struct SubViewModels {
        var categoryViewModel: CategoryViewModel
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(categoryViewModel: CategoryViewModel(dependency:
                                                                                    CategoryViewModel.Dependency(categories: dependency.categories,
                                                                                                                 isStartWith: dependency.isStartWith))
        )
        
        // MARK: Streams
        let categories = subViewModels.categoryViewModel.output.categories
        
        let shouldHideRule = categories
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .startWith(!dependency.categories.isEmpty)
        
        let isValid = shouldHideRule
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            categories: categories,
            shouldHideRule: shouldHideRule,
            isValid: isValid)
    }
}
