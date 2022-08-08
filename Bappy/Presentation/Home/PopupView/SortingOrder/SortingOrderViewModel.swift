//
//  SortingOrderViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/10.
//

import UIKit
import RxSwift
import RxCocoa

protocol SortingOrderViewModelDelegate: AnyObject {
    func selectedSorting(_ sorting: Hangout.SortingOrder)
}

final class SortingOrderViewModel: ViewModelType {
    
    weak var delegate: SortingOrderViewModelDelegate?
    
    struct Dependency {
        var sortingList: [Hangout.SortingOrder] {
            [.Newest, .Nearest, .ManyViews, .manyHearts, .lessSeats]
        }
    }
    
    struct Input {
        var itemSelected: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var sortingList: Driver<[Hangout.SortingOrder]> // <-> View
        var popViewWithSorting: Signal<Hangout.SortingOrder?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let sortingList$: BehaviorSubject<[Hangout.SortingOrder]>
    
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    private let popViewWithSorting$ = PublishSubject<Hangout.SortingOrder?>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let sortingList$ = BehaviorSubject<[Hangout.SortingOrder]>(value: dependency.sortingList)
        
        let sortingList = sortingList$
            .asDriver(onErrorJustReturn: dependency.sortingList)
        let popViewWithSorting = popViewWithSorting$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            sortingList: sortingList,
            popViewWithSorting: popViewWithSorting
        )
        
        // MARK: Bindind
        self.sortingList$ = sortingList$
        
        itemSelected$
            .withLatestFrom(sortingList$) { ($1[$0.row]) }
            .bind(to: popViewWithSorting$)
            .disposed(by: disposeBag)
    }
}
