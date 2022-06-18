//
//  SearchPlaceViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchPlaceViewModel: ViewModelType {
    
    struct Dependency {
        var key: String
        var language: String
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var searchButtonClicked: AnyObserver<Void> // <-> View
        var prefetchRows: AnyObserver<[IndexPath]> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var maps: Driver<[Map]> // <-> View
        var shouldHideNoResultView: Signal<Bool> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var dismissView: Signal<Void> // <-> View
        var showLoader: Signal<Bool> // <-> View
        var dismissLoader: Signal<Void> // <-> View
        var selectedMap: Signal<Map?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let provider: Provider
    
    private let key$: BehaviorSubject<String>
    private let language$: BehaviorSubject<String>
    private let maps$ = BehaviorSubject<[Map]>(value: [])
    private let nextPageToken$ = BehaviorSubject<String?>(value: nil)
    private let usedPageToken$ = BehaviorSubject<[String?]>(value: [])
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let searchButtonClicked$ = PublishSubject<Void>()
    private let prefetchRows$ = PublishSubject<[IndexPath]>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let closeButtonTapped$ = PublishSubject<Void>()
    
    private let showLoader$ = PublishSubject<Bool>()
    private let dismissLoader$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.provider = BappyProvider()
        
        // Streams
        let key$ = BehaviorSubject<String>(value: dependency.key)
        let language$ = BehaviorSubject<String>(value: dependency.language)
        
        let maps = maps$
            .asDriver(onErrorJustReturn: [])
        let shouldHideNoResultView = maps$
            .map { !$0.isEmpty }
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
        let showLoader = showLoader$.asSignal(onErrorJustReturn: false)
        let dismissLoader = dismissLoader$.asSignal(onErrorJustReturn: Void())
        let selectedMap = itemSelected$
            .withLatestFrom(maps$) { $1[$0.row] }
            .asSignal(onErrorJustReturn: nil)
        
        // Input & Output
        self.input = Input(
            text: text$.asObserver(),
            searchButtonClicked: searchButtonClicked$.asObserver(),
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
            selectedMap: selectedMap
        )
        
        // Binding
        self.key$ = key$
        self.language$ = language$
        
        let endPointForNew = searchButtonClicked$
            .withLatestFrom(Observable.combineLatest(key$, text$, language$))
            .distinctUntilChanged { $0.1 == $1.1 }
            .map { MapsRequestDTO(key: $0.0, query: $0.1, language: $0.2) }
            .map(APIEndpoints.searchGoogleMapList)
            .share()
        
        let endPointForExtra = prefetchRows$
            .map { $0.map { $0.row + 1 } }
            .withLatestFrom(maps$) { ($0, $1) }
            .filter { $0.0.contains($0.1.count) }
            .withLatestFrom(
                Observable.combineLatest(
                    key$, nextPageToken$.compactMap { $0 }, language$
                )
            )
            .withLatestFrom(usedPageToken$) { ($0, $1) }
            .filter { !$1.contains($0.1) }
            .map { $0.0 }
            .map { MapsNextRequestDTO(key: $0.0, pagetoken: $0.1, language: $0.2) }
            .map(APIEndpoints.searchGoogleMapNextList)
            .share()
        
        endPointForNew
            .map { _ in false }
            .bind(to: showLoader$)
            .disposed(by: disposeBag)
        
        endPointForExtra
            .map { _ in true }
            .bind(to: showLoader$)
            .disposed(by: disposeBag)
        
        endPointForNew
            .map { _ in [String?]() }
            .bind(to: usedPageToken$)
            .disposed(by: disposeBag)
        
        endPointForExtra
            .withLatestFrom(nextPageToken$)
            .withLatestFrom(usedPageToken$) { $1 + [$0] }
            .bind(to: usedPageToken$)
            .disposed(by: disposeBag)
        
        
        let result = Observable
            .merge(endPointForNew, endPointForExtra)
            .map(provider.request)
            .flatMap { $0 }
            .share()
        
        result
            .map { _ in }
            .bind(to: dismissLoader$)
            .disposed(by: disposeBag)
        
        let value = result
            .compactMap(getValue)
        
        let error = result
            .compactMap(getError)
        
        let valueWithNextPageToken = value
            .withLatestFrom(nextPageToken$) { ($0, $1) }
            .share()
        
        let newMap = valueWithNextPageToken
            .filter { $0.1 == nil }
            .map { $0.0 }
            .map(getMapPage)
            .map { $0.maps }
        
        let extraMap = valueWithNextPageToken
            .filter { $0.1 != nil }
            .map { $0.0 }
            .map(getMapPage)
            .map { $0.maps }
        
        newMap
            .bind(to: maps$)
            .disposed(by: disposeBag)
        
        extraMap
            .withLatestFrom(maps$) { $1 + $0 }
            .bind(to: maps$)
            .disposed(by: disposeBag)
        
        value
            .map(getMapPage)
            .map { $0.nextPageToken }
            .bind(to: nextPageToken$)
            .disposed(by: disposeBag)
        
        error
            .bind(onNext: { print("ERROR: \($0)")})
            .disposed(by: disposeBag)
    }
}

private func getValue(_ result: Result<Endpoint<MapsResponseDTO>.Response, Error>) -> Endpoint<MapsResponseDTO>.Response? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getError(_ result: Result<Endpoint<MapsResponseDTO>.Response, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}

private func getMapPage(response: Endpoint<MapsResponseDTO>.Response) -> MapPage {
    return response.toDomain()
}
