//
//  LanguageSettingViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/05.
//

import UIKit
import RxSwift
import RxCocoa

final class LanguageSettingViewModel: ViewModelType {
    
    struct Dependency {
        var userLanguages: [Language]
    }
    
    struct Input {
        var editingDidBegin: AnyObserver<Void> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
        var itemDeleted: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var closeButtonTapped: Signal<Void> // <-> Parent
        var selectedLanguages: Signal<[Language]> // <-> Parent
        var userLanguages: Driver<[Language]> // <-> View
        var showSearchView: Signal<LanguageSearchViewModel?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let userLanguages$: BehaviorSubject<[Language]>
    private let selectedLanguage$ = PublishSubject<Language>()

    private let editingDidBegin$ = PublishSubject<Void>()
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let itemDeleted$ = PublishSubject<IndexPath>()
    
    private let showSearchView$ = PublishSubject<LanguageSearchViewModel?>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let userLanguages$ = BehaviorSubject<[Language]>(value: dependency.userLanguages)
        
        let closeButtonTapped = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let selectedLanguages = userLanguages$
            .asSignal(onErrorJustReturn: [])
        let userLanguages = userLanguages$
            .asDriver(onErrorJustReturn: [])
        let showSearchView = showSearchView$
            .asSignal(onErrorJustReturn: nil)
        
        // Input & Output
        self.input = Input(
            editingDidBegin: editingDidBegin$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver(),
            itemDeleted: itemDeleted$.asObserver()
        )
        
        self.output = Output(
            closeButtonTapped: closeButtonTapped,
            selectedLanguages: selectedLanguages,
            userLanguages: userLanguages,
            showSearchView: showSearchView
        )
        
        // Bindind
        self.userLanguages$ = userLanguages$
        
        itemDeleted$
            .withLatestFrom(userLanguages$) { indexPath, languages -> [Language] in
                var languageList = languages
                languageList.remove(at: indexPath.row)
                return languageList
            }
            .bind(to: userLanguages$)
            .disposed(by: disposeBag)
        
        editingDidBegin$
            .map { _ ->  LanguageSearchViewModel in
                let viewModel = LanguageSearchViewModel(dependency: .init())
                viewModel.delegate = self
                return viewModel
            }
            .bind(to: showSearchView$)
            .disposed(by: disposeBag)
        
        selectedLanguage$
            .withLatestFrom(userLanguages$) { (language: $0, languages: $1) }
            .filter { !$0.languages.contains($0.language) }
            .map { $0.languages + [$0.language] }
            .bind(to: userLanguages$)
            .disposed(by: disposeBag)
    }
}

// MARK: - LanguageSearchViewModelDelegate
extension LanguageSettingViewModel: LanguageSearchViewModelDelegate {
    func selectedLanguage(_ language: Language) {
        selectedLanguage$.onNext(language)
    }
}
