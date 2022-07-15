//
//  HangoutMakeOpenchatViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeOpenchatViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var editingDidBegin: AnyObserver<Void> // <-> View
        var keyboardWithButtonHeight: AnyObserver<CGFloat> // <-> Parent
    }
    
    struct Output {
        var shouldHideRule: Signal<Bool> // <-> View
        var keyboardWithButtonHeight: Signal<CGFloat> // <-> View
        var openchatText: Signal<String> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let editingDidBegin$ = PublishSubject<Void>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let isOpenchatValid = text$
            .map(validation)
            .share()
        let shouldHideRule = isOpenchatValid
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        let openchatText = text$
            .filter(validation)
            .asSignal(onErrorJustReturn: "")
        let isValid = isOpenchatValid
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            text: text$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        
        self.output = Output(
            shouldHideRule: shouldHideRule,
            keyboardWithButtonHeight: keyboardWithButtonHeight,
            openchatText: openchatText,
            isValid: isValid
        )
    }
}

private func validation(text: String) -> Bool {
    return text.hasPrefix("https://open.kakao.com/o/") &&
    (text.count == 33)
}
