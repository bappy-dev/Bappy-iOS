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
        var minimumLength: Int { 10 }
        var maximumLength: Int { 35 }
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var editingDidBegin: AnyObserver<Void> // <-> View
        var keyboardWithButtonHeight: AnyObserver<CGFloat> // <-> Parent
    }
    
    struct Output {
        var modifiedText: Signal<String> // <-> View
        var shouldHideRule: Signal<Bool> // <-> View
        var keyboardWithButtonHeight: Signal<CGFloat> // <-> View
        var title: Signal<String> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let modifiedText$ = BehaviorSubject<String>(value: "")
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let editingDidBegin$ = PublishSubject<Void>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    private let minimumLength$: BehaviorSubject<Int>
    private let maximumLength$: BehaviorSubject<Int>
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let minimumLength$ = BehaviorSubject<Int>(value: dependency.minimumLength)
        let maximumLength$ = BehaviorSubject<Int>(value: dependency.maximumLength)
        
        let modifiedText = modifiedText$
            .asSignal(onErrorJustReturn: "")
        
        let isTitleValid = modifiedText$
            .withLatestFrom(
                Observable
                    .combineLatest(minimumLength$, maximumLength$),
                resultSelector: validation
            )
            .share()
        let title = modifiedText
        let isValid = isTitleValid
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let shouldHideRule = Observable
            .combineLatest(editingDidBegin$, isTitleValid) { $1 }
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            text: text$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        
        self.output = Output(
            modifiedText: modifiedText,
            shouldHideRule: shouldHideRule,
            keyboardWithButtonHeight: keyboardWithButtonHeight,
            title: title,
            isValid: isValid
        )
        
        // MARK: Binding
        self.minimumLength$ = minimumLength$
        self.maximumLength$ = maximumLength$
        
        text$
            .distinctUntilChanged()
            .withLatestFrom(maximumLength$, resultSelector: removeExcessString)
            .bind(to: modifiedText$)
            .disposed(by: disposeBag)
    }
}

private func validation(text: String, condition: (minimumLength: Int, maximumLength: Int)) -> Bool {
    return (text.count >= condition.minimumLength) && (text.count <= condition.maximumLength)
}

private func removeExcessString(text: String, maximumLength: Int) -> String {
    guard text.count > maximumLength else { return text }
    let startIndex = text.startIndex
    let lastIndex = text.index(startIndex, offsetBy: maximumLength)
    return String(text[startIndex..<lastIndex])
}
