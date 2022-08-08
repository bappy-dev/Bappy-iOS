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
        var shouldHideSelection: Driver<Bool> // <-> View
        var localeButtonTapped: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let isUserUsingGPS$ = BehaviorSubject<Bool>(value: false)
    private let localeButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let shouldHideSelection = isUserUsingGPS$
            .map { !$0 }
            .asDriver(onErrorJustReturn: true)
        let localeButtonTapped = localeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            isUserUsingGPS: isUserUsingGPS$.asObserver(),
            localeButtonTapped: localeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            shouldHideSelection: shouldHideSelection,
            localeButtonTapped: localeButtonTapped
        )
        
        // MARK: Bindind
    }
}
