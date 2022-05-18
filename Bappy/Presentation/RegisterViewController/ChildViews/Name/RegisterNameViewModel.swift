//
//  RegisterNameViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterNameViewModel: ViewModelType {
    struct Dependency {
        var name: String
    }
    
    struct Input {
        var nameText: AnyObserver<String>
    }
    
    struct Output {
        var isNameValid: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let nameText$: BehaviorSubject<String>
    
    init(dependency: Dependency = Dependency(name: "")) {
        self.dependency = dependency
        
        // Streams
        let nameText$ = BehaviorSubject<String>(value: dependency.name)
        let isNameValid$ = nameText$.map(validation)
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(nameText: nameText$.asObserver())
        self.output = Output(isNameValid: isNameValid$)
        
        // Binding
        self.nameText$ = nameText$
    }
}

private func validation(name: String) -> Bool {
    return name.count > 1
}
