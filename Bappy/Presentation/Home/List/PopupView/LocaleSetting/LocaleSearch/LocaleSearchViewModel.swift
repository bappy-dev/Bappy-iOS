//
//  LocaleSearchViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/12.
//

import UIKit
import RxSwift
import RxCocoa

final class LocaleSearchViewModel: ViewModelType {
    
    struct Dependency {
        let googleMapRepository: GoogleMapsRepository
        let bappyAuthRepository: BappyAuthRepository
        var key: String { Bundle.main.googleMapAPIKey }
        var language: String { "en" }
        
        init(googleMapRepository: GoogleMapsRepository = DefaultGoogleMapsRepository(),
             bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared) {
            self.googleMapRepository = googleMapRepository
            self.bappyAuthRepository = bappyAuthRepository
        }
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var searchButtonClicked: AnyObserver<Void> // <-> View
        var willDisplayIndex: AnyObserver<IndexPath> // <-> View
        var prefetchRows: AnyObserver<[IndexPath]> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var maps: Driver<[Map]> // <-> View
        var shouldHideNoResultView: Signal<Bool> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var showLoader: Signal<Bool> // <-> View
        var shouldSpinnerAnimating: Driver<Bool> // <-> View
        var hangouts: Signal<[Hangout]>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let key$: BehaviorSubject<String>
    private let language$: BehaviorSubject<String>
    private let maps$ = BehaviorSubject<[Map]>(value: [])
    private let hangouts$ = BehaviorSubject<[Hangout]>(value: [])
    private let nextPageToken$ = BehaviorSubject<String?>(value: nil)
    private let usedPageToken$ = BehaviorSubject<[String?]>(value: [])
    private let isCommunicating$ = BehaviorSubject<Bool>(value: false)
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let searchButtonClicked$ = PublishSubject<Void>()
    private let willDisplayIndex$ = PublishSubject<IndexPath>()
    private let prefetchRows$ = PublishSubject<[IndexPath]>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let showLoader$ = PublishSubject<Bool>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let key$ = BehaviorSubject<String>(value: dependency.key)
        let language$ = BehaviorSubject<String>(value: dependency.language)
        
        let maps = maps$
            .asDriver(onErrorJustReturn: [])
        let shouldHideNoResultView = Observable
            .combineLatest(maps$, isCommunicating$) { !$0.isEmpty || $1 }
            .asSignal(onErrorJustReturn: true)
        let dismissKeyboard = Observable
            .merge(
                searchButtonClicked$,
                itemSelected$.map { _ in }
            )
            .debug("SearchViewModel")
            .asSignal(onErrorJustReturn: Void())
        let showLoader = showLoader$.asSignal(onErrorJustReturn: false)
        let shouldSpinnerAnimating = nextPageToken$
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        let hangouts = hangouts$
            .asSignal(onErrorJustReturn: [])
        
        // MARK: Input & Output
        self.input = Input(
            text: text$.asObserver(),
            searchButtonClicked: searchButtonClicked$.asObserver(),
            willDisplayIndex: willDisplayIndex$.asObserver(),
            prefetchRows: prefetchRows$.asObserver(),
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            maps: maps,
            shouldHideNoResultView: shouldHideNoResultView,
            dismissKeyboard: dismissKeyboard,
            showLoader: showLoader,
            shouldSpinnerAnimating: shouldSpinnerAnimating,
            hangouts: hangouts
        )
        
        // MARK: Bindind
        self.key$ = key$
        self.language$ = language$
        
        let startForNew = searchButtonClicked$
            .withLatestFrom(Observable.combineLatest(key$, text$, language$))
            .distinctUntilChanged { $0.1 == $1.1 }
            .do { [weak self] _ in
                self?.isCommunicating$.onNext(true)
                self?.showLoader$.onNext(true)
                self?.usedPageToken$.onNext([])
                self?.maps$.onNext([])
            }
            .share()
        
        // prefetchRows에 현재 maps.count가 포함 && pageToken이 존재 && usedPageToken에 포함 X && 통신중 X
        // pageToken 발급 후 등록하기 까지 딜레이가 있어서 debounce 추가
        let startForExtra = prefetchRows$
            .withLatestFrom(maps$) { indexPaths, maps in
                indexPaths.map { $0.row + 1}.contains(maps.count) }
            .withLatestFrom(isCommunicating$) { ($0, $1) }
            .filter { $0.0 && !$0.1 }
            .withLatestFrom(Observable.combineLatest(
                    key$, nextPageToken$.compactMap { $0 }, language$
            ))
            .withLatestFrom(usedPageToken$) { ($0, $1) }
            .filter { !$1.contains($0.1) }
            .map { $0.0 }
            .do { [weak self] _ in self?.isCommunicating$.onNext(true) }
            .debounce(.milliseconds(1200), scheduler: MainScheduler.instance)
            .share()
        
        startForExtra
            .withLatestFrom(nextPageToken$)
            .withLatestFrom(usedPageToken$) { $1 + [$0] }
            .bind(to: usedPageToken$)
            .disposed(by: disposeBag)
        
        let result = Observable
            .merge(
                startForNew.map(dependency.googleMapRepository.fetchMapPage),
                startForExtra.map(dependency.googleMapRepository.fetchNextMapPage)
            )
            .observe(on:MainScheduler.asyncInstance)
            .flatMap { $0 }
            .do { [weak self] _ in
                self?.showLoader$.onNext(false)
                self?.isCommunicating$.onNext(false)
            }
            .share()
        
        let value = result
            .compactMap(getValue)
            .share()
        
        let error = result
            .compactMap(getErrorDescription)
        
        value
            .map { $0.maps }
            .withLatestFrom(maps$) { $1 + $0 }
            .bind(to: maps$)
            .disposed(by: disposeBag)
        
        value
            .map { $0.nextPageToken }
            .bind(to: nextPageToken$)
            .disposed(by: disposeBag)
        
        error
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        let createLocationResult = itemSelected$
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .withLatestFrom(maps$) { $1[$0.row] }
            .map {
                Location(
                    name: $0.name,
                    address: $0.address,
                    coordinates: $0.coordinates,
                    isSelected: false)
            }
            .flatMap(dependency.bappyAuthRepository.createLocation)
            .share()

        createLocationResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        createLocationResult
            .compactMap(getValue)
            .do(onNext: { [weak self] _ in self?.showLoader$.onNext(false) },
                onError: { [weak self] _ in self?.showLoader$.onNext(false)
            })
            .bind(to: hangouts$)
            .disposed(by: disposeBag)
    }
}
