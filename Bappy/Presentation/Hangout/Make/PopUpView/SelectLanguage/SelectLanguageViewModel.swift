//
//  SelectLanguageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectLanguageViewModelDelegate: AnyObject {
    func languageSelected(language: Language)
}

final class SelectLanguageViewModel: ViewModelType {
    weak var delegate: SelectLanguageViewModelDelegate?

    struct Dependency {
        var languages: [Language]
    }

    struct Input {
        var text: AnyObserver<String> // <-> View
        var searchButtonClicked: AnyObserver<Void> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
    }

    struct Output {
        var filteredlanguages: Driver<[Language]> // <-> View
        var shouldHideNoResultView: Signal<Bool> // <-> View
        var dismissKeyboard: Signal<Void> // <-> View
        var dismissView: Signal<Void> // <-> View
    }

    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let provider: Provider

    private let languages$: BehaviorSubject<[Language]>
    private let filteredlanguages$: BehaviorSubject<[Language]>

    private let text$ = BehaviorSubject<String>(value: "")
    private let searchButtonClicked$ = PublishSubject<Void>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let closeButtonTapped$ = PublishSubject<Void>()

    private let showLoader$ = PublishSubject<Void>()
    private let dismissLoader$ = PublishSubject<Void>()

    init(dependency: Dependency) {
        self.dependency = dependency
        self.provider = BappyProvider()

        // Streams
        let languages$ = BehaviorSubject<[Language]>(value: dependency.languages)
        let filteredlanguages$ = BehaviorSubject<[Language]>(value: dependency.languages)

        let filteredlanguages = filteredlanguages$
            .asDriver(onErrorJustReturn: [])
        let shouldHideNoResultView = filteredlanguages
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

        // Input & Output
        self.input = Input(
            text: text$.asObserver(),
            searchButtonClicked: searchButtonClicked$.asObserver(),
            itemSelected: itemSelected$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver()
        )

        self.output = Output(
            filteredlanguages: filteredlanguages,
            shouldHideNoResultView: shouldHideNoResultView,
            dismissKeyboard: dismissKeyboard,
            dismissView: dismissView
        )

        // Binding
        self.languages$ = languages$
        self.filteredlanguages$ = filteredlanguages$

        text$
            .withLatestFrom(languages$) { text, languages -> [Language] in
                return text.isEmpty ?
                languages :
                languages.filter { $0.lowercased().contains(text.lowercased()) }
            }
            .bind(to: filteredlanguages$)
            .disposed(by: disposeBag)

        itemSelected$
            .withLatestFrom(filteredlanguages$) { $1[$0.row] }
            .bind(onNext: { [weak self] language in
                self?.delegate?.languageSelected(language: language)
            })
            .disposed(by: disposeBag)
    }
}
