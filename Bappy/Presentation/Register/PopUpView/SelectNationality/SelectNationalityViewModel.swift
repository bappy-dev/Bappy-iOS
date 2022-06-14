//
//  SelectNationalityViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectNationalityViewModel: ViewModelType {
    
    struct Dependency {
        var country: Country
        var countries: [Country]
    }

    struct Input {
        var countries: AnyObserver<[Country]>
        var text: AnyObserver<String>
        var closeButtonTapped: AnyObserver<Void>
        var itemSelected: AnyObserver<IndexPath>
    }

    struct Output {
        
        var searchedCountries: Driver<[Country]>
        var dismiss: Signal<Void>
        var hideNoResultView: BehaviorRelay<Bool>
        var country: Signal<Country>
    }

    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output

    private let countries$: BehaviorSubject<[Country]>
    private let text$ = PublishSubject<String>()
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let itemSelected$ = PublishSubject<IndexPath>()

    init(dependency: Dependency) {
        self.dependency = dependency

        // Streams
        let countries$ = BehaviorSubject<[Country]>(value: dependency.countries)
        
        let searchedCountries = text$
            .withLatestFrom(countries$, resultSelector: searchCountriesWithText)
            .asDriver(onErrorJustReturn: [])
        let dismiss = Observable
            .merge(closeButtonTapped$, itemSelected$.map { _ in })
            .asSignal(onErrorJustReturn: Void())
        let hideNoResultView = BehaviorRelay<Bool>(value: true)
        let country = itemSelected$
            .withLatestFrom(searchedCountries) { $1[$0.row] }
            .asSignal(onErrorJustReturn: dependency.country)

        // Input & Output
        self.input = Input(
            countries: countries$.asObserver(),
            text: text$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver(),
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            searchedCountries: searchedCountries,
            dismiss: dismiss,
            hideNoResultView: hideNoResultView,
            country: country
        )

        // Binding
        self.countries$ = countries$
        
        searchedCountries
            .map { !$0.isEmpty }
            .drive(hideNoResultView)
            .disposed(by: disposeBag)
    }
}

private func searchCountriesWithText(text: String, countries: [Country]) -> [Country] {
    guard !text.isEmpty else { return countries}
    return countries.filter { $0.name.lowercased().contains(text.lowercased()) }
}
