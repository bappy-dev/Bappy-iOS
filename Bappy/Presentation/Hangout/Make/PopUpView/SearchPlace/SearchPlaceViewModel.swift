//
//  SearchPlaceViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchPlaceViewModelDelegate: AnyObject {
    func mapSelected(map: Map)
}

final class SearchPlaceViewModel: ViewModelType {
    weak var delegate: SearchPlaceViewModelDelegate?
    
    struct Dependency {
        var key: String
        var language: String
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var searchButtonClicked: AnyObserver<Void> // <-> View
        var willDisplayIndex: AnyObserver<IndexPath> // <-> View
        var prefetchRows: AnyObserver<[IndexPath]> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var maps: Driver<[Map]> // <-> View
        var shouldHideNoResultView: Signal<Bool> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var dismissView: Signal<Void> // <-> View
        var showLoader: Signal<Void> // <-> View
        var dismissLoader: Signal<Void> // <-> View
        var shouldSpinnerAnimating: Driver<Bool> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let repository: GoogleMapsRepository
    let provider: Provider
    
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
    private let closeButtonTapped$ = PublishSubject<Void>()
    
    private let showLoader$ = PublishSubject<Void>()
    private let dismissLoader$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.provider = BappyProvider()
        self.repository = DefaultGoogleMapsRepository()
        
        // Streams
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
                itemSelected$.map { _ in },
                closeButtonTapped$
            )
            .asSignal(onErrorJustReturn: Void())
        let dismissView = Observable
            .merge(
                itemSelected$.map { _ in },
                closeButtonTapped$
            )
            .asSignal(onErrorJustReturn: Void())
        let showLoader = showLoader$.asSignal(onErrorJustReturn: Void())
        let dismissLoader = dismissLoader$.asSignal(onErrorJustReturn: Void())
        let shouldSpinnerAnimating = nextPageToken$
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            text: text$.asObserver(),
            searchButtonClicked: searchButtonClicked$.asObserver(),
            willDisplayIndex: willDisplayIndex$.asObserver(),
            prefetchRows: prefetchRows$.asObserver(),
            itemSelected: itemSelected$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            maps: maps,
            shouldHideNoResultView: shouldHideNoResultView,
            dismissKeyboard: dismissKeyboard,
            dismissView: dismissView,
            showLoader: showLoader,
            dismissLoader: dismissLoader,
            shouldSpinnerAnimating: shouldSpinnerAnimating
        )
        
        // Binding
        self.key$ = key$
        self.language$ = language$
        
        let startForNew = searchButtonClicked$
            .withLatestFrom(Observable.combineLatest(key$, text$, language$))
            .distinctUntilChanged { $0.1 == $1.1 }
            .do { [weak self] _ in
                self?.isCommunicating$.onNext(true)
                self?.showLoader$.onNext(Void())
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
                startForNew.map(repository.fetchMapPage),
                startForExtra.map(repository.fetchNextMapPage)
            )
            .flatMap { $0 }
            .do { [weak self] _ in
                self?.dismissLoader$.onNext(Void())
                self?.isCommunicating$.onNext(false)
            }
            .share()
        
        let value = result
            .compactMap(getValue)
            .share()
        
        let error = result
            .compactMap(getError)
        
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
            .bind(onNext: { print("ERROR: \($0)")})
            .disposed(by: disposeBag)
        
        itemSelected$
            .withLatestFrom(maps$) { $1[$0.row] }
            .bind(onNext: { [weak self] map in
                self?.delegate?.mapSelected(map: map)
            })
            .disposed(by: disposeBag)
    }
}

private func getValue(_ result: Result<MapPage, Error>) -> MapPage? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getError(_ result: Result<MapPage, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}
