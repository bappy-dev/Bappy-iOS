//
//  MoveWithKeyboardViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MoveWithKeyboardViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var backButtonTapped: AnyObserver<Void>
        var text: AnyObserver<String>
        var buttonTapped: AnyObserver<Void>
        var isButtonEnabled: AnyObserver<Bool>
    }
    
    struct Output {
        var backButtonTapped: Signal<Void>
        var text: Signal<String>
        var continueButtonTapped: Signal<Void>
        var isButtonEnabled: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let text$ = PublishSubject<String>()
    private let buttonTapped$ = PublishSubject<Void>()
    private let isButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let backButtonTapped = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let text = text$
            .asSignal(onErrorJustReturn: "")
        let buttonTapped = buttonTapped$
            .asSignal(onErrorJustReturn: Void())
        let isButtonEnabled = isButtonEnabled$
            .asDriver(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            text: text$.asObserver(),
            buttonTapped: buttonTapped$.asObserver(),
            isButtonEnabled: isButtonEnabled$.asObserver()
        )
        
        self.output = Output(
            backButtonTapped: backButtonTapped,
            text: text,
            continueButtonTapped: buttonTapped,
            isButtonEnabled: isButtonEnabled
        )
    }
}
