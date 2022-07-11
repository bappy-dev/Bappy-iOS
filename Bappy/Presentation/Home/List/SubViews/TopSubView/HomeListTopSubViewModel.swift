//
//  HomeListTopSubViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeListTopSubViewModel: ViewModelType {
    
    struct Dependency {
        var categories: [Hangout.Category] {
            [.All, .Travel, .Study, .Sports, .Food,
             .Drinks, .Cook, .Cook, .Culture,
             .Volunteer, .Language, .Crafting]
        }
    }
    
    struct Input {
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var sortingButtonTapped: AnyObserver<Void> // <-> View
        var sorting: AnyObserver<Hangout.Sorting> // <-> Parent
    }
    
    struct Output {
        var sortingButtonTapped: Signal<Void> // <-> Parent
        var sorting: Driver<String> // <-> View
        var categories: Driver<[Dictionary<Hangout.Category, Bool>.Element]> // <-> View
        var category: Driver<Hangout.Category> // <-> Parent
    }
    
    private let categories$: BehaviorSubject<[Hangout.Category]>
    
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let sortingButtonTapped$ = PublishSubject<Void>()
    private let sorting$ = BehaviorSubject<Hangout.Sorting>(value: .Newest)
    
    private let category$: BehaviorSubject<Hangout.Category>
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let categories$ = BehaviorSubject<[Hangout.Category]>(value: dependency.categories)
        let category$ = BehaviorSubject<Hangout.Category>(value: .All)
        
        let sortingButtonTapped = sortingButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let sorting = sorting$
            .map { $0.description }
            .asDriver(onErrorJustReturn: Hangout.Sorting.Newest.description)
        let categories = category$
            .withLatestFrom(categories$) { category, categories -> [Dictionary<Hangout.Category, Bool>.Element] in
                return categories.flatMap { [$0: $0 == category] }
            }
            .asDriver(onErrorJustReturn: [])
        let category = category$
            .asDriver(onErrorJustReturn: .All)
        
        // Input & Output
        self.input = Input(
            itemSelected: itemSelected$.asObserver(),
            sortingButtonTapped: sortingButtonTapped$.asObserver(),
            sorting: sorting$.asObserver()
        )
        
        self.output = Output(
            sortingButtonTapped: sortingButtonTapped,
            sorting: sorting,
            categories: categories,
            category: category
        )
        
        // Bindind
        self.categories$ = categories$
        self.category$ = category$
        
        itemSelected$
            .withLatestFrom(categories$) { $1[$0.item] }
            .bind(to: category$)
            .disposed(by: disposeBag)
    }
}
