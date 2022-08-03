//
//  LocaleSearchViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/12.
//

import UIKit
import RxSwift
import RxCocoa

protocol LocaleSearchViewModelDelegate: AnyObject {
    func mapSelected(map: Map)
}

final class LocaleSearchViewModel: ViewModelType {
    
    struct Dependency {
        let googleMapRepository: GoogleMapsRepository
        var key: String { Bundle.main.googleMapAPIKey }
        var language: String { "en" }
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
        var popView: Signal<Void> // <-> View
    }
    
    weak var delegate: LocaleSearchViewModelDelegate?
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let key$: BehaviorSubject<String>
    private let language$: BehaviorSubject<String>
    private let maps$ = BehaviorSubject<[Map]>(value: [])
    private let nextPageToken$ = BehaviorSubject<String?>(value: nil)
    private let usedPageToken$ = BehaviorSubject<[String?]>(value: [])
    private let isCommunicating$ = BehaviorSubject<Bool>(value: false)
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let searchButtonClicked$ = PublishSubject<Void>()
    private let willDisplayIndex$ = PublishSubject<IndexPath>()
    private let prefetchRows$ = PublishSubject<[IndexPath]>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    private let showLoader$ = PublishSubject<Bool>()
    private let popView$ = PublishSubject<Void>()
    
    init(dependency: Dependency = .init(googleMapRepository: DefaultGoogleMapsRepository())) {
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
            .asSignal(onErrorJustReturn: Void())
        let showLoader = showLoader$.asSignal(onErrorJustReturn: false)
        let shouldSpinnerAnimating = nextPageToken$
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        let popView = popView$
            .asSignal(onErrorJustReturn: Void())
        
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
            popView: popView
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
        
        itemSelected$
            .withLatestFrom(maps$) { $1[$0.row] }
            .do { _ in self.popView$.onNext(Void()) }
            .bind(onNext: { [weak self] map in
                self?.delegate?.mapSelected(map: map)
            })
            .disposed(by: disposeBag)

    }
}
