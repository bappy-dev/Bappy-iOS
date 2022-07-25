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
        var locationRepository: LocationRepository
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
        var moreButtonTapped: AnyObserver<IndexPath> // <-> View
        var likeButtonTapped: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var scrollToTop: Signal<Void> // <-> View
        var hangouts: Driver<[Hangout]> // <-> View
        var showLocaleView: Signal<HomeLocaleViewModel?> // <-> View
        var showSearchView: Signal<HomeSearchViewModel?> // <-> View
        var showSortingView: Signal<SortingOrderViewModel?> // <-> View
        var showDetailView: Signal<HangoutDetailViewModel?> // <-> View
        var sorting: Driver<Hangout.Sorting> // <-> Child(TopSub)
    }
    
    var dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let currentUser$: BehaviorSubject<BappyUser?>
    private let sorting$ = BehaviorSubject<Hangout.Sorting>(value: .Newest)
    private let category$ = BehaviorSubject<Hangout.Category>(value: .All)
    private let location$: BehaviorSubject<CLLocationCoordinate2D?>
    
    private let hangouts$ = BehaviorSubject<[Hangout]>(value: [])
    
    private let scrollToTop$ = PublishSubject<Void>()
    private let localeButtonTapped$ = PublishSubject<Void>()
    private let searchButtonTapped$ = PublishSubject<Void>()
    private let filterButtonTapped$ = PublishSubject<Void>()
    private let sortingButtonTapped$ = PublishSubject<Void>()
    private let moreButtonTapped$ = PublishSubject<IndexPath>()
    private let likeButtonTapped$ = PublishSubject<IndexPath>()
    
    private let showSortingView$ = PublishSubject<SortingOrderViewModel?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            topViewModel: HomeListTopViewModel(dependency: .init()),
            topSubViewModel: HomeListTopSubViewModel(dependency: .init())
        )
        
        // Streams
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        let location$ = dependency.locationRepository.location
        
        let scrollToTop = scrollToTop$
            .asSignal(onErrorJustReturn: Void())
        let hangouts = hangouts$
            .asDriver(onErrorJustReturn: [])
        let showLocaleView = localeButtonTapped$
            .map { _ -> HomeLocaleViewModel in
                let dependency = HomeLocaleViewModel.Dependency(
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    locationRepsitory: dependency.locationRepository)
                return HomeLocaleViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let showSearchView = searchButtonTapped$
            .map { _ -> HomeSearchViewModel in
                let dependency = HomeSearchViewModel.Dependency()
                return HomeSearchViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let showSortingView = showSortingView$
            .asSignal(onErrorJustReturn: nil)
        let showDetailView = moreButtonTapped$
            .withLatestFrom(hangouts) { $1[$0.row] }
            .withLatestFrom(currentUser$.compactMap { $0 }) { (user: $1, hangout: $0) }
            .map { element -> HangoutDetailViewModel in
                let dependency = HangoutDetailViewModel.Dependency(
                    firebaseRepository: DefaultFirebaseRepository.shared,
                    currentUser: element.user,
                    hangout: element.hangout)
                return HangoutDetailViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let sorting = sorting$
            .asDriver(onErrorJustReturn: .Newest)
        
        // Input & Output
        self.input = Input(
            scrollToTop: scrollToTop$.asObserver(),
            localeButtonTapped: localeButtonTapped$.asObserver(),
            searchButtonTapped: searchButtonTapped$.asObserver(),
            filterButtonTapped: filterButtonTapped$.asObserver(),
            sortingButtonTapped: sortingButtonTapped$.asObserver(),
            moreButtonTapped: moreButtonTapped$.asObserver(),
            likeButtonTapped: likeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            scrollToTop: scrollToTop,
            hangouts: hangouts,
            showLocaleView: showLocaleView,
            showSearchView: showSearchView,
            showSortingView: showSortingView,
            showDetailView: showDetailView,
            sorting: sorting
        )
        
        // Bindind
        self.currentUser$ = currentUser$
        self.location$ = location$
        
        // User의 저장된 GPS가 true이고, 위치권한이 있을 때 실시간 위치정보 사용
        currentUser$
            .compactMap(\.?.isUserUsingGPS)
            .withLatestFrom(dependency.locationRepository.authorization) { $0 && $1 == .authorizedWhenInUse }
            .bind(onNext: dependency.locationRepository.turnGPSSetting)
            .disposed(by: disposeBag)
        
        let hangoutsResult = Observable
            .combineLatest(
                currentUser$.compactMap { $0 },
                sorting$,
                category$
            )
            .map { ("\($0.1.rawValue)", "", "", "") }
            .flatMap(dependency.hangoutRepository.fetchHangouts)
            .share()
        
        hangoutsResult
            .compactMap(getHangoutsError)
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        hangoutsResult
            .compactMap(getHangouts)
            .bind(to: hangouts$)
            .disposed(by: disposeBag)
        
        let likeButtonFlow = likeButtonTapped$
            .withLatestFrom(hangouts$) { (indexPath: $0, hangouts: $1) }
            .share()
        
        likeButtonFlow
            .map { element -> [Hangout] in
                var hangouts = element.hangouts
                let row = element.indexPath.row
                var hangout = hangouts[row]
                hangout.userHasLiked = !hangout.userHasLiked
                hangouts[row] = hangout
                return hangouts
            }
            .bind(to: hangouts$)
            .disposed(by: disposeBag)
        
//        likeButtonFlow
//            .map(dependency.hangoutRepository.)
        
        sortingButtonTapped$
            .map { _ -> SortingOrderViewModel in
                let dependency = SortingOrderViewModel.Dependency()
                let viewModel = SortingOrderViewModel(dependency: dependency)
                viewModel.delegate = self
                return viewModel
            }
            .bind(to: showSortingView$)
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

private func getHangouts(_ result: Result<[Hangout], Error>) -> [Hangout]? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getHangoutsError(_ result: Result<[Hangout], Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}

// MARK: - SortingOrderViewModelDelegate
extension HomeListViewModel: SortingOrderViewModelDelegate {
    func selectedSorting(_ sorting: Hangout.Sorting) {
        sorting$.onNext(sorting)
    }
}


