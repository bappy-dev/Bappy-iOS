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
        var name: String
        var minimumLength: Int
        var maximumLength: Int
    }
    
    struct Input {
        var name: AnyObserver<String>
        var minimumLength: AnyObserver<Int>
        var maximumLength: AnyObserver<Int>
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
    
    private let name$: BehaviorSubject<String>
    private let minimumLength$: BehaviorSubject<Int>
    private let maximumLength$: BehaviorSubject<Int>
    private let editingDidBegin$ = PublishSubject<Void>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    
    init(dependency: Dependency = Dependency(name: "", minimumLength: 0, maximumLength: 0)) {
        self.dependency = dependency
        
        // Streams
        let name$ = BehaviorSubject<String>(value: dependency.name)
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
            .combineLatest(editingDidBegin$, isNameValid)
            .map { $1 }
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        
        // Input & Output
        self.input = Input(
            name: name$.asObserver(),
            minimumLength: minimumLength$.asObserver(),
            maximumLength: maximumLength$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        self.output = Output(
            isValid: isValid,
            modifiedName: modifiedName,
            shouldHideRule: shouldHideRule,
            keyboardWithButtonHeight: keyboardWithButtonHeight
        )
        
        // Binding
        self.name$ = name$
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
