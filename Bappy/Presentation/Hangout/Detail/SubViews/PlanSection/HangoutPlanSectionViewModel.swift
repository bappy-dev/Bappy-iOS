//
//  HangoutPlanSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutPlanSectionViewModel: ViewModelType {
    
    struct Dependency {
        var hangout: Hangout
        var plan: String { hangout.plan }
    }
    
    struct Input {}
    
    struct Output {
        var planText: Signal<String>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let plan$: BehaviorSubject<String>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let plan$ = BehaviorSubject<String>(value: dependency.plan)
        
        let planText = plan$
            .asSignal(onErrorJustReturn: dependency.plan)
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            planText: planText
        )
        
        // MARK: Bindind
        self.plan$ = plan$
    }
}
