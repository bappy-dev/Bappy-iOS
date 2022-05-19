//
//  BottomButtonViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/17.
//

import UIKit
import RxSwift
import RxCocoa

final class BottomButtonViewModel: ViewModelType {
    
    struct Dependency {
        var isFirstPage: Bool
        var isLastPage: Bool
        var isContentValid: Bool
    }

    struct Input {
        var isContentValid: AnyObserver<Bool>
        var isFirstPage: AnyObserver<Bool>
        var isLastPage: AnyObserver<Bool>
        var didTapPreviousButton: AnyObserver<Void>
        var didTapNextButton: AnyObserver<Void>
    }
    
    struct Output {
        var isNextButtonActivated: Driver<Bool>
        var shouldPreviousButtonHide: Driver<Bool>
        var shouldBeCompleted: Driver<Bool>
        var didTapPreviousButton: Signal<Void>
        var didTapNextButton: Signal<Void>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let isContentValid$: BehaviorSubject<Bool>
    private let isFirstPage$: BehaviorSubject<Bool>
    private let isLastPage$: BehaviorSubject<Bool>
    private let didTapPreviousButton$: PublishSubject<Void>
    private let didTapNextButton$: PublishSubject<Void>
    
    init(dependency: Dependency = Dependency(isFirstPage: true, isLastPage: false, isContentValid: false)) {
        self.dependency = dependency
        
        // Streams
        let isContentValid$ = BehaviorSubject<Bool>(value: dependency.isContentValid)
        let isFirstPage$ = BehaviorSubject<Bool>(value: dependency.isFirstPage)
        let isLastPage$ = BehaviorSubject<Bool>(value: dependency.isLastPage)
        let didTapPreviousButton$ = PublishSubject<Void>()
        let didTapNextButton$ = PublishSubject<Void>()
        
        let isNextButtonActivated$ = isContentValid$.asDriver(onErrorJustReturn: false)
        let shouldPreviousButtonHide$ = isFirstPage$.asDriver(onErrorJustReturn: false)
        let shouldBeCompleted$ = isLastPage$.asDriver(onErrorJustReturn: false)
        let didTapPreviousButton = didTapPreviousButton$.asSignal(onErrorJustReturn: Void())
        let didTapNextButton = didTapNextButton$.asSignal(onErrorJustReturn: Void())

        // Input & Output
        self.input = Input(isContentValid: isContentValid$.asObserver(),
                           isFirstPage: isFirstPage$.asObserver(),
                           isLastPage: isLastPage$.asObserver(),
                           didTapPreviousButton: didTapPreviousButton$.asObserver(),
                           didTapNextButton: didTapNextButton$.asObserver())
        self.output = Output(isNextButtonActivated: isNextButtonActivated$,
                             shouldPreviousButtonHide: shouldPreviousButtonHide$,
                             shouldBeCompleted: shouldBeCompleted$,
                             didTapPreviousButton: didTapPreviousButton,
                             didTapNextButton: didTapNextButton)

        // Binding
        self.isContentValid$ = isContentValid$
        self.isFirstPage$ = isFirstPage$
        self.isLastPage$ = isLastPage$
        self.didTapPreviousButton$ = didTapPreviousButton$
        self.didTapNextButton$ = didTapNextButton$
    }
}
