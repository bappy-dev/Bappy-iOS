//
//  RegisterViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/15.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterViewModel: ViewModelType {
    
    struct SubViewModels {
        let nameViewModel: RegisterNameViewModel
        let bottomButtonViewModel: BottomButtonViewModel
    }
    
    struct Dependency {
        var page: Int
        var numOfPage: Int
    }
    
    struct Input {
        var page: AnyObserver<Int>
        var numOfPage: AnyObserver<Int>
        var goNextPage: AnyObserver<Void>
        var goPreviousPage: AnyObserver<Void>
//        var isNameValid: AnyObserver<Bool>
    }
    
    struct Output {
//        var isNameValid: Driver<Bool>
        var pageContentOffset: Driver<CGPoint>
        var progression: Driver<CGFloat>
//        var isContentValid: Driver<Bool>
//        var isFirstPage: Driver<Bool>
//        var isLastPage: Driver<Bool>
//        var shouldKeyboardShow: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    let subViewModels = SubViewModels(
        nameViewModel: RegisterNameViewModel(),
        bottomButtonViewModel: BottomButtonViewModel()
    )
    
    private let page$: BehaviorSubject<Int>
    private let numOfPage$: BehaviorSubject<Int>
    private let goNextPage$ = PublishSubject<Void>()
    private let goPreviousPage$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency(page: 0, numOfPage: 0)) {
        self.dependency = dependency
        
        // Streams
        let page$ = BehaviorSubject<Int>(value: dependency.page)
        let numOfPage$ = BehaviorSubject<Int>(value: dependency.numOfPage)
        
        let pageContentOffset$ = page$.map(getContentOffset)
            .asDriver(onErrorJustReturn: .zero)
        let progression$ = page$.withLatestFrom(numOfPage$.filter { $0 != 0 },
                                                resultSelector: getProgression)
            .asDriver(onErrorJustReturn: .zero)
//        let shouldKeyboardShow$ = page$.map { false }
            
        
        // Input & Output
        self.input = Input(page: page$.asObserver(),
                           numOfPage: numOfPage$.asObserver(),
                           goNextPage: goNextPage$.asObserver(),
                           goPreviousPage: goPreviousPage$.asObserver())
        self.output = Output(pageContentOffset: pageContentOffset$,
                             progression: progression$)
//                             isContentValid: <#T##Driver<Bool>#>,
//                             isFirstPage: <#T##Driver<Bool>#>,
//                             isLastPage: <#T##Driver<Bool>#>)
        
        // Binding
        self.page$ = page$
        self.numOfPage$ = numOfPage$
        
        goNextPage$.withLatestFrom(Observable.combineLatest(page$, numOfPage$))
            .filter { $0.0 + 1 < $0.1 }
            .map { $0.0 + 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        goPreviousPage$.withLatestFrom(page$)
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        subViewModels.bottomButtonViewModel.output.didTapPreviousButton
            .emit(to: goPreviousPage$)
            .disposed(by: disposeBag)
        
        subViewModels.bottomButtonViewModel.output.didTapNextButton
            .emit(to: goNextPage$)
            .disposed(by: disposeBag)
    }
}

private func getContentOffset(page: Int) -> CGPoint {
    let x = UIScreen.main.bounds.width * CGFloat(page)
    return CGPoint(x: x, y: 0)
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}
