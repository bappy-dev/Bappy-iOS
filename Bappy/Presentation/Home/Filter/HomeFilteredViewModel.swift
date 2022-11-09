//
//  HomeFilteredViewModel.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/20.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeFilteredViewModel: ViewModelType {
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let hangoutRepository: HangoutRepository
        
        init(bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared,
             hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.bappyAuthRepository = bappyAuthRepository
            self.hangoutRepository = hangoutRepository
        }
    }
    
    struct Input {
        var filteringView: AnyObserver<Void>
        var scrollToTop: AnyObserver<Void> // <-> Parent
        var refresh: AnyObserver<Void> // <-> View
        var viewDidAppear: AnyObserver<Void>
    }
    
    struct Output {
        var endRefreshing: Signal<Void> // <-> View
        var hideHolderView: Signal<Bool> // <-> View
        var cellViewModels: Driver<[HangoutCellViewModel]> // <-> View
        var spinnerAnimating: Signal<Bool> // <-> View
        var showFilteringView: Signal<HomeFilterViewModel?>
    }
    
    struct SubViewModels {
        let filterViewModel: HomeFilterViewModel
    }
    
    var dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let currentUser$: BehaviorSubject<BappyUser?>
    private let cellViewModels$ = BehaviorSubject<[HangoutCellViewModel]>(value: [])
    private let scrollToTop$ = PublishSubject<Void>()
    private let refresh$ = PublishSubject<Void>()
    private let hideHolderView$ = PublishSubject<Bool>()
    private let endRefreshing$ = PublishSubject<Void>()
    private let spinnerAnimating$ = PublishSubject<Bool>()
    private let viewDidAppear$ = PublishSubject<Void>()
    private let filteringView$ = PublishSubject<Void>()
    private let showFilteringView = PublishSubject<HomeFilterViewModel?>()
    
    
    init(dependency: Dependency = Dependency()) {
       let filterSubViewModel = HomeFilterViewModel()
        
        self.dependency = dependency
        self.subViewModels = SubViewModels(filterViewModel: filterSubViewModel)
        
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        
        let endRefreshing = endRefreshing$
            .asSignal(onErrorJustReturn: Void())
        let hideHolderView = hideHolderView$
            .asSignal(onErrorJustReturn: true)
        let spinnerAnimating = spinnerAnimating$
            .asSignal(onErrorJustReturn: false)
        let cellViewModels = cellViewModels$
            .asDriver(onErrorJustReturn: [])
        let filterView = showFilteringView
            .asSignal(onErrorJustReturn: nil)
        
        self.input = Input(filteringView: filteringView$.asObserver(),
                           scrollToTop: scrollToTop$.asObserver(),
                           refresh: refresh$.asObserver(),
                           viewDidAppear: viewDidAppear$.asObserver())
        
        self.output = Output(endRefreshing: endRefreshing,
                             hideHolderView: hideHolderView,
                             cellViewModels: cellViewModels,
                             spinnerAnimating: spinnerAnimating,
                             showFilteringView: filterView)
        
        self.currentUser$ = currentUser$
        
        Observable.merge(filteringView$, viewDidAppear$)
            .map { _ -> HomeFilterViewModel in
                return filterSubViewModel
            }
            .bind(to: showFilteringView)
            .disposed(by: disposeBag)
        
        subViewModels.filterViewModel.output.filterForm
            .map { _ in false }
            .emit(to: hideHolderView$)
            .disposed(by: disposeBag)
        
        let filtered = subViewModels.filterViewModel.output.filterForm
            .asObservable()
            .flatMap(dependency.hangoutRepository.filterHangouts)
            .share()
        
        filtered
            .map { _ in true }
            .bind(to: hideHolderView$)
            .disposed(by: disposeBag)

        let filteredHangouts = filtered
            .compactMap(getValue)
            .map { $0.hangouts }
            .share()

        filteredHangouts
            .withLatestFrom(currentUser$.compactMap { $0 }) { (hangouts: $0, user: $1) }
            .map { element -> [HangoutCellViewModel] in
                
                if element.hangouts.isEmpty {
                    return []
                } else {
                    return element.hangouts.map { hangout -> HangoutCellViewModel in
                        let dependency = HangoutCellViewModel.Dependency(
                            user: element.user, hangout: hangout)
                        let viewModel = HangoutCellViewModel(dependency: dependency)
                        return viewModel
                    }
                }
            }.bind(to: cellViewModels$)
            .disposed(by: disposeBag)
    }
}
