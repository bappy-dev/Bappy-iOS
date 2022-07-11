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
    func selectedSorting(_ sorting: Hangout.Sorting)
}

final class SortingOrderViewModel: ViewModelType {
    
    weak var delegate: SortingOrderViewModelDelegate?
    
    struct Dependency {
        var sortingList: [Hangout.Sorting] {
            [.Newest, .Nearest, .ManyViews, .manyHearts, .lessSeats]
        }
    }
    
    struct Input {
        var itemSelected: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var sortingList: Driver<[Hangout.Sorting]> // <-> View
        var popView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let sortingList$: BehaviorSubject<[Hangout.Sorting]>
    
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let sortingList$ = BehaviorSubject<[Hangout.Sorting]>(value: dependency.sortingList)
        
        let sortingList = sortingList$
            .asDriver(onErrorJustReturn: dependency.sortingList)
        let popView = itemSelected$
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            sortingList: sortingList,
            popView: popView
        )
        
        // Bindind
        self.sortingList$ = sortingList$
        
        itemSelected$
            .withLatestFrom(sortingList$) { ($1[$0.row]) }
            .bind(onNext: { [weak self] sorting in
                self?.delegate?.selectedSorting(sorting)
            })
            .disposed(by: disposeBag)
    }
}
