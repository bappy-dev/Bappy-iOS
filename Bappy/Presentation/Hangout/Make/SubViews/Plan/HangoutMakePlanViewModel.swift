//
//  HangoutMakePlanViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakePlanViewModel: ViewModelType {
    struct Dependency {
        var minimumLength: Int { 14 }
        var maximumLength: Int { 200 }
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var editingDidBegin: AnyObserver<Void> // <-> View
        var keyboardWithButtonHeight: AnyObserver<CGFloat> // <-> Parent
    }
    
    struct Output {
        var modifiedText: Signal<String> // <-> View
        var keyboardWithButtonHeight: Signal<CGFloat> // <->View
        var shouldHidePlaceholder: Signal<Bool> // <-> View
        var shouldHideRule: Signal<Bool> // <-> View
        var countInfo: Driver<String> // <-> View
        var plan: Signal<String> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let modifiedText$ = BehaviorSubject<String>(value: "")
    private let countInfo$: BehaviorSubject<String>
    
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
        let countInfo$ = BehaviorSubject<String>(value: "(0/\(dependency.maximumLength))")
        
        let modifiedText = modifiedText$
            .asSignal(onErrorJustReturn: "")
        
        let isPlanValid = modifiedText$
            .withLatestFrom(
                Observable
                    .combineLatest(minimumLength$, maximumLength$),
                resultSelector: validation
            )
            .share()
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        let shouldHidePlaceholder = text$
            .map { $0.count > 0 }
            .asSignal(onErrorJustReturn: true)
        let shouldHideRule = Observable
            .combineLatest(editingDidBegin$, isPlanValid) { $1 }
            .asSignal(onErrorJustReturn: false)
        let countInfo = countInfo$
            .asDriver(onErrorJustReturn: "(0/\(dependency.maximumLength))")
        let plan = modifiedText
        let isValid = isPlanValid
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            text: text$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        
        self.output = Output(
            modifiedText: modifiedText,
            keyboardWithButtonHeight: keyboardWithButtonHeight,
            shouldHidePlaceholder: shouldHidePlaceholder,
            shouldHideRule: shouldHideRule,
            countInfo: countInfo,
            plan: plan,
            isValid: isValid
        )
        
        // MARK: Binding
        self.minimumLength$ = minimumLength$
        self.maximumLength$ = maximumLength$
        self.countInfo$ = countInfo$
        
        text$
            .distinctUntilChanged()
            .withLatestFrom(maximumLength$, resultSelector: removeExcessString)
            .bind(to: modifiedText$)
            .disposed(by: disposeBag)
        
        modifiedText$
            .withLatestFrom(maximumLength$) { "(\($0.count)/\($1))" }
            .bind(to: countInfo$)
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
