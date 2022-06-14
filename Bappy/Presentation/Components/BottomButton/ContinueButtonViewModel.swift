//
//  ContinueButtonViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/13.
//

import UIKit
import RxSwift
import RxCocoa

final class ContinueButtonViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var buttonTapped: AnyObserver<Void>
        var isButtonEnabled: AnyObserver<Bool>
    }
    
    struct Output {
        var continueButtonTapped: Signal<Void>
        var isButtonEnabled: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let buttonTapped$ = PublishSubject<Void>()
    private let isButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let buttonTapped = buttonTapped$
            .asSignal(onErrorJustReturn: Void())
        let isButtonEnabled = isButtonEnabled$
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            buttonTapped: buttonTapped$.asObserver(),
            isButtonEnabled: isButtonEnabled$.asObserver()
        )
        
        self.output = Output(
            continueButtonTapped: buttonTapped,
            isButtonEnabled: isButtonEnabled
        )
    }
}
