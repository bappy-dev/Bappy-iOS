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
        var languages: [Language] {
            [
                "Arabic", "Catalan", "Chinese", "Croatian", "Czech", "Danish", "Dutch", "English", "Finnish", "French", "German", "Greek", "Hebrew", "Hindi", "Hungarian", "Indonesian", "Italian", "Japanese", "Korean", "Malay", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Slovak", "Spanish", "Swedish", "Thai", "Turkish", "Ukrainian", "Vietnamese"
            ]
        }
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

    private let languages$: BehaviorSubject<[Language]>
    private let filteredlanguages$: BehaviorSubject<[Language]>

    private let text$ = BehaviorSubject<String>(value: "")
    private let searchButtonClicked$ = PublishSubject<Void>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let closeButtonTapped$ = PublishSubject<Void>()

    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency

        // MARK: Streams
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

        // MARK: Input & Output
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

        // MARK: Binding
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
