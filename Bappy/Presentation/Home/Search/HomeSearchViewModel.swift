//
//  HomeSearchViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

final class HomeSearchViewModel: ViewModelType {
    
    struct Dependency {
        var user: BappyUser
        let hangoutRepository: HangoutRepository
        
        init(user: BappyUser,
             hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.user = user
            self.hangoutRepository = hangoutRepository
        }
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var searchButtonClicked: AnyObserver<Void> // <-> View
        var willDisplayRow: AnyObserver<Int> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var backButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var scrollToTop: Signal<Void> // <-> View
        var cellViewModels: Driver<[HangoutCellViewModel]> // <-> View
        var showDetailView: Signal<HangoutDetailViewModel?> // <-> View
        var hideNoResultView: Signal<Bool> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var popView: Signal<Void> // <-> View
        var showLoader: Signal<Bool> // <-> View
        var spinnerAnimating: Signal<Bool> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
    private let page$ = BehaviorSubject<Int>(value: 1)
    private let totalPage$ = BehaviorSubject<Int>(value: 1)
    private let searchedText$ = BehaviorSubject<String>(value: "")
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let searchButtonClicked$ = PublishSubject<Void>()
    private let willDisplayRow$ = PublishSubject<Int>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let backButtonTapped$ = PublishSubject<Void>()
    
    private let scrollToTop$ = PublishSubject<Void>()
    private let cellViewModels$ = BehaviorSubject<[HangoutCellViewModel]>(value: [])
    private let showLoader$ = PublishSubject<Bool>()
    private let showDetailView$ = PublishSubject<HangoutDetailViewModel>()
    private let hideNoResultView$ = PublishSubject<Bool>()
    private let spinnerAnimating$ = PublishSubject<Bool>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let scrollToTop = scrollToTop$
            .asSignal(onErrorJustReturn: Void())
        let cellViewModels = cellViewModels$
            .asDriver(onErrorJustReturn: [])
        let showDetailView = showDetailView$
            .map(HangoutDetailViewModel?.init)
            .asSignal(onErrorJustReturn: nil)
        let hideNoResultView = cellViewModels
            .map { !$0.isEmpty }
            .asSignal(onErrorJustReturn: true)
        let dismissKeyboard = searchButtonClicked$
            .asSignal(onErrorJustReturn: Void())
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showLoader = showLoader$
            .asSignal(onErrorJustReturn: false)
        let spinnerAnimating = spinnerAnimating$
            .asSignal(onErrorJustReturn: false)
        
        
        // MARK: Input & Output
        self.input = Input(
            text: text$.asObserver(),
            searchButtonClicked: searchButtonClicked$.asObserver(),
            willDisplayRow: willDisplayRow$.asObserver(),
            itemSelected: itemSelected$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver()
        )
        
        self.output = Output(
            scrollToTop: scrollToTop,
            cellViewModels: cellViewModels,
            showDetailView: showDetailView,
            hideNoResultView: hideNoResultView,
            dismissKeyboard: dismissKeyboard,
            popView: popView,
            showLoader: showLoader,
            spinnerAnimating: spinnerAnimating
        )
        
        // MARK: Bindind
        self.user$ = user$
        
        // 검색 버튼 클릭 Flow
        let newHangoutFlow = searchButtonClicked$
            .withLatestFrom(text$) { ($1)}
            .share()
        
        newHangoutFlow
            .bind(to: searchedText$)
            .disposed(by: disposeBag)
        
        let newHangoutPageResult = newHangoutFlow
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .flatMap(dependency.hangoutRepository.searchHangouts)
            .observe(on: MainScheduler.asyncInstance)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .share()
        
        // Error 디버깅
        newHangoutPageResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        let newHangoutPage = newHangoutPageResult
            .compactMap(getValue)
            .share()
        
        newHangoutPage
            .map(\.totalPage)
            .bind(to: totalPage$)
            .disposed(by: disposeBag)
        
        newHangoutPage
            .map(\.hangouts)
            .withLatestFrom(user$) { (hangouts: $0, user: $1) }
            .map { [weak self] element -> [HangoutCellViewModel] in
                element.hangouts.map { hangout -> HangoutCellViewModel in
                    let dependency = HangoutCellViewModel.Dependency(
                        user: element.user, hangout: hangout)
                    let viewModel = HangoutCellViewModel(dependency: dependency)
                    if let self = self {
                        viewModel.output.showDetailView
                            .compactMap { $0 }
                            .emit(to: self.showDetailView$)
                            .disposed(by: viewModel.disposeBag)
                    }
                    return viewModel
                }
            }
            .do { [weak self] _ in self?.scrollToTop$.onNext(Void()) }
            .bind(to: cellViewModels$)
            .disposed(by: disposeBag)
        
        //        extraHangoutPage
        //            .map(\.hangouts)
        //            .withLatestFrom(user$) { (hangouts: $0, user: $1) }
        //            .map { [weak self] element -> [HangoutCellViewModel] in
        //                element.hangouts.map { hangout -> HangoutCellViewModel in
        //                    let dependency = HangoutCellViewModel.Dependency(
        //                        user: element.user, hangout: hangout)
        //                    let viewModel = HangoutCellViewModel(dependency: dependency)
        //                    if let self = self {
        //                        viewModel.output.showDetailView
        //                            .compactMap { $0 }
        //                            .emit(to: self.showDetailView$)
        //                            .disposed(by: viewModel.disposeBag)
        //                    }
        //                    return viewModel
        //                }
        //            }
        //            .withLatestFrom(cellViewModels$) { $1 + $0 }
        //            .bind(to: cellViewModels$)
        //            .disposed(by: disposeBag)
        
        // willDisplayRow가 마지막 전 Cell의 인덱스를 건드리고, totalPage가 page 보다 클 때 page 1 증가 시키기
        willDisplayRow$
            .withLatestFrom(
                cellViewModels$
                    .map(\.count)
                    .distinctUntilChanged()
            ) { (row: $0, count: $1) }
            .filter { $0.row == $0.count - 2 }
            .withLatestFrom(page$)
            .withLatestFrom(totalPage$) { (page: $0, totalPage: $1) }
            .filter { $0.page < $0.totalPage }
            .map { $0.page + 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        // Spinner StartAnimating
        Observable
            .combineLatest(page$, totalPage$)
            .map { $0 < $1 }
            .filter { $0 }
            .bind(to: spinnerAnimating$)
            .disposed(by: disposeBag)
        
        // Spinner StopAnimating
        newHangoutPage
            .map(\.totalPage)
            .withLatestFrom(page$) { (totalPage: $0, page: $1) }
            .filter { $0.totalPage == $0.page }
            .map { _ in false }
            .bind(to: spinnerAnimating$)
            .disposed(by: disposeBag)
    }
}
