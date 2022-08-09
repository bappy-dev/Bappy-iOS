//
//  HangoutMakeLimitViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeLimitViewModel: ViewModelType {
    
    struct Dependency {
        var minimumNumber: Int { 4 }
        var maximumNumber: Int { 10 }
    }
    
    struct Input {
        var minusButtonTapped: AnyObserver<Void> // <-> View
        var plusButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var numberText: Signal<String> // <-> View
        var description: Signal<String> // <-> View
        var isMinusButtonEnabled: Signal<Bool> // <-> View
        var isPlusButtonEnabled: Signal<Bool> // <-> View
        var limit: Signal<Int> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let number$: BehaviorSubject<Int>
    private let minimumNumber$: BehaviorSubject<Int>
    private let maximumNumber$: BehaviorSubject<Int>
    
    private let minusButtonTapped$ = PublishSubject<Void>()
    private let plusButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let number$ = BehaviorSubject<Int>(value: dependency.minimumNumber)
        let minimumNumber$ = BehaviorSubject<Int>(value: dependency.minimumNumber)
        let maximumNumber$ = BehaviorSubject<Int>(value: dependency.maximumNumber)
        
        let numberText = number$
            .map { "\($0)" }
            .asSignal(onErrorJustReturn: "\(dependency.minimumNumber)")
        let description = Observable
            .combineLatest(minimumNumber$, maximumNumber$)
            .map { "Participants Limit  \($0.0) ~ \($0.1)" }
            .asSignal(onErrorJustReturn: "Participants Limit  \(dependency.minimumNumber) ~ \(dependency.maximumNumber)")
        let isMinusButtonEnabled = number$
            .withLatestFrom(minimumNumber$) { $0 != $1 }
            .asSignal(onErrorJustReturn: false)
        let isPlusButtonEnabled = number$
            .withLatestFrom(maximumNumber$) { $0 != $1 }
            .asSignal(onErrorJustReturn: false)
        let limit = number$
            .asSignal(onErrorJustReturn: dependency.minimumNumber)
        
        // MARK: Input & Output
        self.input = Input(
            minusButtonTapped: minusButtonTapped$.asObserver(),
            plusButtonTapped: plusButtonTapped$.asObserver()
        )
        
        self.output = Output(
            numberText: numberText,
            description: description,
            isMinusButtonEnabled: isMinusButtonEnabled,
            isPlusButtonEnabled: isPlusButtonEnabled,
            limit: limit
        )
        
        // MARK: Binding
        self.number$ = number$
        self.minimumNumber$ = minimumNumber$
        self.maximumNumber$ = maximumNumber$
        
        minusButtonTapped$
            .withLatestFrom(number$)
            .withLatestFrom(minimumNumber$) { ($0, $1) }
            .filter { $0.0 > $0.1 }
            .map { $0.0 - 1 }
            .bind(to: number$)
            .disposed(by: disposeBag)
        
        plusButtonTapped$
            .withLatestFrom(number$)
            .withLatestFrom(maximumNumber$) { ($0, $1) }
            .filter { $0.0 < $0.1 }
            .map { $0.0 + 1 }
            .bind(to: number$)
            .disposed(by: disposeBag)
    }
}
