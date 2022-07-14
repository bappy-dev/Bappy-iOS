//
//  LocaleSettingHeaderViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/13.
//

import UIKit
import RxSwift
import RxCocoa

final class LocaleSettingHeaderViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var isUserUsingGPS: AnyObserver<Bool> // <-> Parent
        var localeButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var shouldHideSelection: Signal<Bool> // <-> View
        var localeButtonTapped: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let isUserUsingGPS$ = PublishSubject<Bool>()
    private let localeButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let shouldHideSelection = isUserUsingGPS$
            .map { !$0 }
            .asSignal(onErrorJustReturn: true)
        let localeButtonTapped = localeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            isUserUsingGPS: isUserUsingGPS$.asObserver(),
            localeButtonTapped: localeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            shouldHideSelection: shouldHideSelection,
            localeButtonTapped: localeButtonTapped
        )
        
        // Bindind
    }
}
