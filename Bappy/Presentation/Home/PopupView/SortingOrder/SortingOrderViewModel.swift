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
        var popView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let sortingList$: BehaviorSubject<[Hangout.SortingOrder]>
    
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let sortingList$ = BehaviorSubject<[Hangout.SortingOrder]>(value: dependency.sortingList)
        
        let sortingList = sortingList$
            .asDriver(onErrorJustReturn: dependency.sortingList)
        let popView = itemSelected$
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            sortingList: sortingList,
            popView: popView
        )
        
        // MARK: Bindind
        self.sortingList$ = sortingList$
        
        itemSelected$
            .withLatestFrom(sortingList$) { ($1[$0.row]) }
            .bind(onNext: { [weak self] sorting in
                self?.delegate?.selectedSorting(sorting)
            })
            .disposed(by: disposeBag)
    }
}
