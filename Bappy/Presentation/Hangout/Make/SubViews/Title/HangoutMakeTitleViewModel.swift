//
//  HangoutMakeTitleViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeTitleViewModel: ViewModelType {
    struct Dependency {
        var minimumLength: Int
        var maximumLength: Int
    }
    
    struct Input {
        var text: AnyObserver<String>
        var editingDidBegin: AnyObserver<Void>
        var keyboardWithButtonHeight: AnyObserver<CGFloat>
    }
    
    struct Output {
        var modifiedText: Signal<String>
        var isValid: Driver<Bool>
        var shouldHideRule: Signal<Bool>
        var keyboardWithButtonHeight: Signal<CGFloat>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let editingDidBegin$ = PublishSubject<Void>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    private let minimumLength$: BehaviorSubject<Int>
    private let maximumLength$: BehaviorSubject<Int>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let minimumLength$ = BehaviorSubject<Int>(value: dependency.minimumLength)
        let maximumLength$ = BehaviorSubject<Int>(value: dependency.maximumLength)
        
        let modifiedText = text$
            .distinctUntilChanged()
            .withLatestFrom(maximumLength$, resultSelector: removeExcessString)
            .asSignal(onErrorJustReturn: "")
        
        let isTitleValid = text$
            .withLatestFrom(
                Observable
                    .combineLatest(minimumLength$, maximumLength$),
                resultSelector: validation
            )
            .share()
        let isValid = isTitleValid
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        let shouldHideRule = Observable
            .combineLatest(editingDidBegin$, isTitleValid) { $1 }
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        
        // Input & Output
        self.input = Input(
            text: text$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        
        self.output = Output(
            modifiedText: modifiedText,
            isValid: isValid,
            shouldHideRule: shouldHideRule,
            keyboardWithButtonHeight: keyboardWithButtonHeight
        )
        
        // Binding
        self.minimumLength$ = minimumLength$
        self.maximumLength$ = maximumLength$
        
        modifiedText
            .emit(to: text$)
            .disposed(by: disposeBag)
    }
}

private func validation(text: String, condition: (minimumLength: Int, maximumLength: Int)) -> Bool {
    return (text.count >= condition.minimumLength)
            && (text.count <= condition.maximumLength)
}

private func removeExcessString(text: String, maximumLength: Int) -> String {
    guard text.count > maximumLength else { return text }
    let startIndex = text.startIndex
    let lastIndex = text.index(startIndex, offsetBy: maximumLength)
    return String(text[startIndex..<lastIndex])
}
