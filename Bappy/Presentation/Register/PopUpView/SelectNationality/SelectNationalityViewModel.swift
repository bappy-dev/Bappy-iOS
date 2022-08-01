//
//  SelectNationalityViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectNationalityViewModelDelegate: AnyObject {
    func selectedCountry(_ country: Country)
}

final class SelectNationalityViewModel: ViewModelType {
    
    weak var delegate: SelectNationalityViewModelDelegate?
    
    struct Dependency {
        var countries: [Country] {
            NSLocale.isoCountryCodes
                .map { NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]) }
                .map { countryCode -> Country in
                    let code = String(countryCode[countryCode.index(after: countryCode.startIndex)...])
                    return Country(code: code)
                }
        }
    }

    struct Input {
        var text: AnyObserver<String> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
    }

    struct Output {
        var searchedCountries: Driver<[Country]> // <-> View
        var dismiss: Signal<Void> // <-> View
        var hideNoResultView: Driver<Bool> // <-> View
    }

    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output

    private let countries$: BehaviorSubject<[Country]>
    private let text$ = PublishSubject<String>()
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    private let hideNoResultView$ = BehaviorSubject<Bool>(value: true)

    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency

        // MARK: Streams
        let countries$ = BehaviorSubject<[Country]>(value: dependency.countries)
        
        let searchedCountries = text$
            .withLatestFrom(countries$, resultSelector: searchCountriesWithText)
            .asDriver(onErrorJustReturn: [])
        let dismiss = Observable
            .merge(closeButtonTapped$, itemSelected$.map { _ in })
            .asSignal(onErrorJustReturn: Void())
        let hideNoResultView = hideNoResultView$
            .asDriver(onErrorJustReturn: true)

        // MARK: Input & Output
        self.input = Input(
            text: text$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver(),
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            searchedCountries: searchedCountries,
            dismiss: dismiss,
            hideNoResultView: hideNoResultView
        )

        // MARK: Binding
        self.countries$ = countries$
        
        searchedCountries
            .map { !$0.isEmpty }
            .drive(hideNoResultView$)
            .disposed(by: disposeBag)
        
        itemSelected$
            .withLatestFrom(searchedCountries) { $1[$0.row] }
            .bind(onNext: { [weak self] country in
                self?.delegate?.selectedCountry(country)
            })
            .disposed(by: disposeBag)
    }
}

private func searchCountriesWithText(text: String, countries: [Country]) -> [Country] {
    guard !text.isEmpty else { return countries }
    return countries.filter { $0.name.lowercased().contains(text.lowercased()) }
}
