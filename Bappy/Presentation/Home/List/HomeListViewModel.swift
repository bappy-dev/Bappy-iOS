//
//  HomeListViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class HomeListViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let hangoutRepository: HangoutRepository
        let locationRepository: CLLocationRepository
        
        init(bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared,
             hangoutRepository: HangoutRepository = DefaultHangoutRepository(),
             locationRepository: CLLocationRepository = DefaultCLLocationRepository.shared) {
            self.bappyAuthRepository = bappyAuthRepository
            self.hangoutRepository = hangoutRepository
            self.locationRepository = locationRepository
        }
    }
    
    struct SubViewModels {
        let topViewModel: HomeListTopViewModel
        let topSubViewModel: HomeListTopSubViewModel
    }
    
    struct Input {
        var scrollToTop: AnyObserver<Void> // <-> Parent
        var localeButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var searchButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var filterButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var sortingButtonTapped: AnyObserver<Void> // <-> Child(TopSub)
        var viewWillDisappear: AnyObserver<Bool> // <-> View
        var refresh: AnyObserver<Void> // <-> View
        var willDisplayRow: AnyObserver<Int> // <-> View
        var showDetailView: AnyObserver<HangoutDetailViewModel> // <-> CellViewModel
    }
    
    struct Output {
        var scrollToTop: Signal<Void> // <-> View
        var cellViewModels: Driver<[HangoutCellViewModel]> // <-> View
        var showLocaleView: Signal<HomeLocationViewModel?> // <-> View
        var showSearchView: Signal<HomeSearchViewModel?> // <-> View
        var showFilteredView: Signal<HomeFilteredViewModel?> // <-> View
        var showSortingView: Signal<SortingOrderViewModel?> // <-> View
        var showDetailView: Signal<HangoutDetailViewModel?> // <-> View
        var hideHolderView: Signal<Bool> // <-> View
        var endRefreshing: Signal<Void> // <-> View
        var spinnerAnimating: Signal<Bool> // <-> View
        var showLocationSettingAlert: Signal<Void> // <-> View
        var showSignInAlert: Signal<String?> // <-> View
        var sorting: Driver<Hangout.SortingOrder> // <-> Child(TopSub)
    }
    
    var dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let currentUser$: BehaviorSubject<BappyUser?>
    private let page$ = BehaviorSubject<Int>(value: 1)
    private let totalPage$ = BehaviorSubject<Int>(value: 1)
    private let sorting$ = BehaviorSubject<Hangout.SortingOrder>(value: .Newest)
    private let category$ = BehaviorSubject<Hangout.Category>(value: .ALL)
    private let coordinates$ = BehaviorSubject<Coordinates?>(value: nil)
    
    private let cellViewModels$ = BehaviorSubject<[HangoutCellViewModel]>(value: [])
    
    private let scrollToTop$ = PublishSubject<Void>()
    private let localeButtonTapped$ = PublishSubject<Void>()
    private let searchButtonTapped$ = PublishSubject<Void>()
    private let filterButtonTapped$ = PublishSubject<Void>()
    private let sortingButtonTapped$ = PublishSubject<Void>()
    private let viewWillDisappear$ = PublishSubject<Bool>()
    private let refresh$ = PublishSubject<Void>()
    private let willDisplayRow$ = PublishSubject<Int>()
    private let showDetailView$ = PublishSubject<HangoutDetailViewModel>()
    
    private let showSortingView$ = PublishSubject<SortingOrderViewModel?>()
    private let hideHolderView$ = PublishSubject<Bool>()
    private let endRefreshing$ = PublishSubject<Void>()
    private let spinnerAnimating$ = PublishSubject<Bool>()
    private let showLocationSettingAlert$ = PublishSubject<Void>()
    private let showSignInAlert$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            topViewModel: HomeListTopViewModel(),
            topSubViewModel: HomeListTopSubViewModel()
        )
        
        // MARK: Streams
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        
        let scrollToTop = scrollToTop$
            .asSignal(onErrorJustReturn: Void())
        let cellViewModels = cellViewModels$
            .asDriver(onErrorJustReturn: [])
        let showLocaleView = localeButtonTapped$
            .withLatestFrom(currentUser$)
            .compactMap(\.?.state)
            .filter { $0 == .normal }
            .map { _ in HomeLocationViewModel() }
            .asSignal(onErrorJustReturn: nil)
        let showSearchView = searchButtonTapped$
            .withLatestFrom(currentUser$.compactMap { $0 })
            .map { user -> HomeSearchViewModel? in
                let dependency = HomeSearchViewModel.Dependency(user: user)
                return HomeSearchViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let showFilteredView = filterButtonTapped$
            .map { _ -> HomeFilteredViewModel? in
                return HomeFilteredViewModel()
            }.asSignal(onErrorJustReturn: nil)
        let showSortingView = showSortingView$
            .asSignal(onErrorJustReturn: nil)
        let showDetailView = showDetailView$
            .map(HangoutDetailViewModel?.init)
            .asSignal(onErrorJustReturn: nil)
        let hideHolderView = hideHolderView$
            .asSignal(onErrorJustReturn: true)
        let endRefreshing = endRefreshing$
            .asSignal(onErrorJustReturn: Void())
        let spinnerAnimating = spinnerAnimating$
            .asSignal(onErrorJustReturn: false)
        let showLocationSettingAlert = showLocationSettingAlert$
            .asSignal(onErrorJustReturn: Void())
        let sorting = sorting$
            .asDriver(onErrorJustReturn: .Newest)
        let showSignInAlert = showSignInAlert$
            .map { _ in "Sign in to use location based services!" }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            scrollToTop: scrollToTop$.asObserver(),
            localeButtonTapped: localeButtonTapped$.asObserver(),
            searchButtonTapped: searchButtonTapped$.asObserver(),
            filterButtonTapped: filterButtonTapped$.asObserver(),
            sortingButtonTapped: sortingButtonTapped$.asObserver(),
            viewWillDisappear: viewWillDisappear$.asObserver(),
            refresh: refresh$.asObserver(),
            willDisplayRow: willDisplayRow$.asObserver(),
            showDetailView: showDetailView$.asObserver()
        )
        
        self.output = Output(
            scrollToTop: scrollToTop,
            cellViewModels: cellViewModels,
            showLocaleView: showLocaleView,
            showSearchView: showSearchView,
            showFilteredView: showFilteredView,
            showSortingView: showSortingView,
            showDetailView: showDetailView,
            hideHolderView: hideHolderView,
            endRefreshing: endRefreshing,
            spinnerAnimating: spinnerAnimating,
            showLocationSettingAlert: showLocationSettingAlert,
            showSignInAlert: showSignInAlert,
            sorting: sorting
        )
        
        // MARK: Bindind
        self.currentUser$ = currentUser$
        
        // Guest 모드시 위치 설정 불가
        localeButtonTapped$
            .withLatestFrom(currentUser$)
            .compactMap(\.?.state)
            .filter { $0 == .anonymous }
            .map { _ in }
            .bind(to: showSignInAlert$)
            .disposed(by: disposeBag)
        
        // Page 1로 초기화
        Observable
            .merge(
                sorting$.map { _ in },
                category$.map { _ in },
                refresh$
            )
            .skip(3)
            .map { _ in 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        // 행아웃 불러오기 Flow
        let hangoutFlow = page$
            .observe(on: MainScheduler.asyncInstance)
            .withLatestFrom(Observable.combineLatest(
                sorting$,
                category$
            )) { ($0, $1.0, $1.1) }
//            .withLatestFrom(coordinates$) { (page: $0.0, sorting: $0.1, category: $0.2, coordinates: $1) }
            .share()
        
        // Page 1일 때 dataSource 새로 만들기
        let newHangoutPageResult = hangoutFlow
            .filter { $0.0 == 1 }
            .flatMap(dependency.hangoutRepository.fetchHangouts)
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        // Page 1보다 클 때 기존 dataSource에 추가하기
        let extraHangoutPageResult = hangoutFlow
            .filter { $0.0 > 1 }
            .flatMap(dependency.hangoutRepository.fetchHangouts)
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        // 최초 1회 dataSource 불러오면 Holder 숨기기
        newHangoutPageResult
            .take(1)
            .map { _ in true }
            .bind(to: hideHolderView$)
            .disposed(by: disposeBag)
        
        // Error 디버깅
        Observable
            .merge(newHangoutPageResult, extraHangoutPageResult)
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        let newHangoutPage = newHangoutPageResult
            .compactMap(getValue)
            .share()
        
        let extraHangoutPage = extraHangoutPageResult
            .compactMap(getValue)
            .share()
        
        // totalPage 업데이트
        Observable
            .merge(newHangoutPage, extraHangoutPage)
            .do { [weak self] _ in self?.endRefreshing$.onNext(Void()) }
            .map(\.totalPage)
            .map { $0 / 10 + 1 }
            .bind(to: totalPage$)
            .disposed(by: disposeBag)
        
        newHangoutPage
            .map(\.hangouts)
            .withLatestFrom(currentUser$.compactMap { $0 }) { (hangouts: $0, user: $1) }
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
        
        extraHangoutPage
            .map(\.hangouts)
            .withLatestFrom(currentUser$.compactMap { $0 }) { (hangouts: $0, user: $1) }
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
            .withLatestFrom(cellViewModels$) { $1 + $0 }
            .bind(to: cellViewModels$)
            .disposed(by: disposeBag)
        
        // willDisplayRow가 마지막 전 Cell의 인덱스를 건드리고, totalPage가 page 보다 클 때 page 1 증가 시키기
        willDisplayRow$
            .withLatestFrom(
                cellViewModels$
                    .map(\.count)
                    .distinctUntilChanged()
            ) { (row: $0, count: $1) }
            .filter { $0.row == $0.count - 2 }
            .withLatestFrom(page$) { $1 }
            .withLatestFrom(totalPage$) { (page: $0, totalPage: $1) }
            .filter { $0.page < $0.totalPage }
            .map { $0.page + 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        // Spinner StarAnimating
        Observable
            .combineLatest(page$, totalPage$)
            .map { $0 < $1 }
            .filter { $0 }
            .bind(to: spinnerAnimating$)
            .disposed(by: disposeBag)
        
        // Spinner StopAnimating
        Observable
            .merge(newHangoutPage, extraHangoutPage)
            .map(\.totalPage)
            .map { $0 / 10 + 1 }
            .withLatestFrom(page$) { (totalPage: $0, page: $1) }
            .filter { $0.totalPage == $0.page }
            .map { _ in false }
            .bind(to: spinnerAnimating$)
            .disposed(by: disposeBag)
        
        // User의 저장된 GPS가 true이고, 위치권한이 있을 때 실시간 위치정보 사용
        Observable
            .combineLatest(
                sorting$,
                currentUser$.compactMap { $0 },
                dependency.locationRepository.authorization
            )
            .map {
                $0.0 == .Nearest &&
                $0.1.isUserUsingGPS ?? false &&
                $0.2 == .authorizedWhenInUse
            }
            .distinctUntilChanged()
            .bind(onNext: dependency.locationRepository.turnGPSSetting)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                sorting$,
                Observable.merge(
                    currentUser$.compactMap { $0 }.map(\.coordinates),
                    dependency.locationRepository.location
                )
            )
            .map { (sorting: $0.0, coordinates$: $0.1) }
            .map { element -> Coordinates? in
                guard element.sorting == .Nearest else { return nil }
                return element.coordinates$
            }
            .bind(to: coordinates$)
            .disposed(by: disposeBag)
        
        // SortingOrderView 띄우기
        sortingButtonTapped$
            .map { _ -> SortingOrderViewModel in
                let viewModel = SortingOrderViewModel()
                viewModel.delegate = self
                return viewModel
            }
            .bind(to: showSortingView$)
            .disposed(by: disposeBag)
        
        // ViewWillDisappear 호출 시 GPS 사용 끄기
        viewWillDisappear$
            .map { _ in false }
            .bind(onNext: dependency.locationRepository.turnGPSSetting)
            .disposed(by: disposeBag)
        
        // Child(Top)
        subViewModels.topViewModel.output.localeButtonTapped
            .emit(to: localeButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.topViewModel.output.searchButtonTapped
            .emit(to: searchButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.topViewModel.output.filterButtonTapped
            .emit(to: filterButtonTapped$)
            .disposed(by: disposeBag)
        
        // Child(TopSub)
        sorting
            .drive(subViewModels.topSubViewModel.input.sorting)
            .disposed(by: disposeBag)
        
        subViewModels.topSubViewModel.output.sortingButtonTapped
            .emit(to: sortingButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.topSubViewModel.output.category
            .drive(category$)
            .disposed(by: disposeBag)
    }
}

// MARK: - SortingOrderViewModelDelegate
extension HomeListViewModel: SortingOrderViewModelDelegate {
    func selectedSorting(_ sorting: Hangout.SortingOrder) {
        if sorting == .Nearest {
            guard let user = try? currentUser$.value(),
                  let authorization = try? dependency.locationRepository.authorization.value()
            else { return }
            guard user.state != .anonymous else {
                showSignInAlert$.onNext(Void())
                return
            }
            
            guard ((user.isUserUsingGPS ?? false) && authorization == .authorizedWhenInUse) || user.coordinates != nil else {
                showLocationSettingAlert$.onNext(Void())
                return
            }
        }
        sorting$.onNext(sorting)
    }
}
