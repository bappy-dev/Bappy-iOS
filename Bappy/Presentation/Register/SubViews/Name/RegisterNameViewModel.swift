//
//  RegisterNameViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterNameViewModel: ViewModelType {
    struct Dependency {
        var minimumLength: Int { 3 }
        var maximumLength: Int { 30 }
    }
    
    struct Input {
        var name: AnyObserver<String>
        var editingDidBegin: AnyObserver<Void>
        var keyboardWithButtonHeight: AnyObserver<CGFloat>
    }
    
    struct Output {
        var isValid: Driver<Bool>
        var modifiedName: Signal<String>
        var shouldHideRule: Signal<Bool>
        var keyboardWithButtonHeight: Signal<CGFloat>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let name$ = BehaviorSubject<String>(value: "")
    private let minimumLength$: BehaviorSubject<Int>
    private let maximumLength$: BehaviorSubject<Int>
    private let editingDidBegin$ = PublishSubject<Void>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let minimumLength$ = BehaviorSubject<Int>(value: dependency.minimumLength)
        let maximumLength$ = BehaviorSubject<Int>(value: dependency.maximumLength)
        
        let isNameValid = name$
            .withLatestFrom(minimumLength$, resultSelector: validation)
            .share()
        let isValid = isNameValid
            .asDriver(onErrorJustReturn: false)
        let modifiedName = name$
            .withLatestFrom(maximumLength$, resultSelector: removeExcessString)
            .asSignal(onErrorJustReturn: "")
        let shouldHideRule = Observable
            .combineLatest(editingDidBegin$, isNameValid) { $1 }
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            name: name$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        self.output = Output(
            isValid: isValid,
            modifiedName: modifiedName,
            shouldHideRule: shouldHideRule,
            keyboardWithButtonHeight: keyboardWithButtonHeight
        )
        
        // MARK: Binding
        self.minimumLength$ = minimumLength$
        self.maximumLength$ = maximumLength$
    }
}

private func validation(name: String, minimumLength: Int) -> Bool {
    return name.count >= minimumLength
}

private func removeExcessString(name: String, maximumLength: Int) -> String {
    guard name.count > maximumLength else { return name }
    let startIndex = name.startIndex
    let lastIndex = name.index(startIndex, offsetBy: maximumLength)
    return String(name[startIndex..<lastIndex])
}
