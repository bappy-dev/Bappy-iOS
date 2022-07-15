//
//  HangoutMakeLanguageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeLanguageViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var language: AnyObserver<Language?> // <-> Parent
        var editingDidBegin: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var text: Signal<String?> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var showSelectLanguageView: Signal<Void> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let language$ = PublishSubject<Language?>()
    private let editingDidBegin$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let text = language$
            .asSignal(onErrorJustReturn: nil)
        let dismissKeyboard = editingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let showSelectLanguageView = dismissKeyboard
        let isValid = language$
            .map { $0 != nil }
            .asSignal(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            language: language$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver()
        )
        
        self.output = Output(
            text: text,
            dismissKeyboard: dismissKeyboard,
            showSelectLanguageView: showSelectLanguageView,
            isValid: isValid
        )
    }
}
