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
        var shouldHideRule: Signal<Bool>
        var userName: Signal<String>
        var isThreeOrThirty: Signal<Bool>
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
        
        let isNameValid = Observable.combineLatest(name$, minimumLength$, maximumLength$)
            .map { validation(name: $0, minimumLength: $1, maximumLength: $2)}
            .share()
        
        let isThreeOrThirty = name$
            .map { $0.count }
            .map { cnt -> Bool? in
                if cnt > 30 {
                    return false
                } else if cnt <= 3 {
                    return true
                }
                return nil
            }.asSignal(onErrorJustReturn: nil)
            .compactMap{ $0 }
        
        let isValid = isNameValid
            .asDriver(onErrorJustReturn: false)
        
        let userName = name$
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
            shouldHideRule: shouldHideRule,
            userName: userName,
            isThreeOrThirty: isThreeOrThirty,
            keyboardWithButtonHeight: keyboardWithButtonHeight
        )
        
        // MARK: Binding
        self.minimumLength$ = minimumLength$
        self.maximumLength$ = maximumLength$
    }
}

private func validation(name: String, minimumLength: Int, maximumLength: Int) -> Bool {
    return name.count >= minimumLength && name.count <= maximumLength
}
