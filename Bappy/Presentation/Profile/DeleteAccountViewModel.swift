//
//  DeleteAccountViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa

final class DeleteAccountViewModel: ViewModelType {
    
    struct SubViewModels {
        let firstPageViewModel: DeleteAccountFirstPageViewModel
        let secondPageViewModel: DeleteAccountSecondPageViewModel
    }
    
    struct Dependency {
        var dropdownList: [String]
    }
    
    struct Input {
        var backButtonTapped: AnyObserver<Void> // <-> View
        var cancelButtonTapped: AnyObserver<Void> // <-> View
        var confirmButtonTapped: AnyObserver<Void> // <-> View
        var isReasonSelected: AnyObserver<Bool> // <-> Child(Second)
    }
    
    struct Output {
        var page: Driver<Int> // <-> View
        var popView: Signal<Void> // <-> View
        var isConfirmButtonEnabled: Driver<Bool> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let page$ = BehaviorSubject<Int>(value: 0)
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let cancelButtonTapped$ = PublishSubject<Void>()
    private let confirmButtonTapped$ = PublishSubject<Void>()
    private let isReasonSelected$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            firstPageViewModel: DeleteAccountFirstPageViewModel(),
            secondPageViewModel: DeleteAccountSecondPageViewModel(
                dependency: .init(dropdownList: dependency.dropdownList)
            )
        )
        
        // Streams
        let page = page$
            .asDriver(onErrorJustReturn: 0)
        let popView = Observable
            .merge(backButtonTapped$, cancelButtonTapped$)
            .asSignal(onErrorJustReturn: Void())
        let isConfirmButtonEnabled = Observable
            .combineLatest(isReasonSelected$, page$)
            .map { ($1 == 0) || ($1 == 1 && $0) }
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            cancelButtonTapped: cancelButtonTapped$.asObserver(),
            confirmButtonTapped: confirmButtonTapped$.asObserver(),
            isReasonSelected: isReasonSelected$.asObserver()
        )
        
        self.output = Output(
            page: page,
            popView: popView,
            isConfirmButtonEnabled: isConfirmButtonEnabled
        )
        
        // Bindind
        confirmButtonTapped$
            .withLatestFrom(page$)
            .filter { $0 == 0 }
            .map { _ in 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        subViewModels.secondPageViewModel.output.isReasonSelected
            .emit(to: isReasonSelected$)
            .disposed(by: disposeBag)
    }
}
