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
        var languageSettingSection: [LanguageSettingSection] {
            return [.init(items: userLanguages)]
        }
    }
    
    struct Input {
        var editingDidBegin: AnyObserver<Void> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
        var editButtonTapped: AnyObserver<Void> // <-> View
        var itemDeleted: AnyObserver<IndexPath> // <-> View
        var itemMoved: AnyObserver<ItemMovedEvent> // <-> View
    }
    
    struct Output {
        var closeButtonTapped: Signal<Void> // <-> Parent
        var selectedLanguages: Signal<[Language]> // <-> Parent
        var languageSettingSection: Driver<[LanguageSettingSection]> // <-> View
        var shouldHideEditButton: Driver<Bool> // <-> View
        var editButtonTitle: Driver<String> // <-> View
        var showSearchView: Signal<LanguageSearchViewModel?> // <-> View
        var isEditing: Signal<Bool> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let languageSettingSection$: BehaviorSubject<[LanguageSettingSection]>
    private let selectedLanguage$ = PublishSubject<Language>()
    private let isEditing$ = BehaviorSubject<Bool>(value: false)

    private let editingDidBegin$ = PublishSubject<Void>()
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let editButtonTapped$ = PublishSubject<Void>()
    private let itemDeleted$ = PublishSubject<IndexPath>()
    private let itemMoved$ = PublishSubject<ItemMovedEvent>()
    
    private let showSearchView$ = PublishSubject<LanguageSearchViewModel?>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let languageSettingSection$ = BehaviorSubject<[LanguageSettingSection]>(value: dependency.languageSettingSection)
        
        let closeButtonTapped = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let selectedLanguages = languageSettingSection$
            .map { $0.flatMap(\.items) }
            .asSignal(onErrorJustReturn: [])
        let languageSettingSection = languageSettingSection$
            .asDriver(onErrorJustReturn: [])
        let shouldHideEditButton = languageSettingSection$
            .map { $0.flatMap(\.items) }
            .map(\.isEmpty)
            .asDriver(onErrorJustReturn: true)
        let editButtonTitle = isEditing$
            .map { $0 ? "Done  " : "Edit  " }
            .asDriver(onErrorJustReturn: "Edit  ")
        let showSearchView = showSearchView$
            .asSignal(onErrorJustReturn: nil)
        let isEditing = isEditing$
            .asSignal(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            editingDidBegin: editingDidBegin$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver(),
            editButtonTapped: editButtonTapped$.asObserver(),
            itemDeleted: itemDeleted$.asObserver(),
            itemMoved: itemMoved$.asObserver()
        )
        
        self.output = Output(
            closeButtonTapped: closeButtonTapped,
            selectedLanguages: selectedLanguages,
            languageSettingSection: languageSettingSection,
            shouldHideEditButton: shouldHideEditButton,
            editButtonTitle: editButtonTitle,
            showSearchView: showSearchView,
            isEditing: isEditing
        )
        
        // MARK: Bindind
        self.languageSettingSection$ = languageSettingSection$
        
        editButtonTapped$
            .withLatestFrom(isEditing$)
            .map { !$0 }
            .bind(to: isEditing$)
            .disposed(by: disposeBag)
        
        itemDeleted$
            .withLatestFrom(languageSettingSection$) { indexPath, sections -> [LanguageSettingSection] in
                var sections = sections
                var section = sections[indexPath.section]
                section.items.remove(at: indexPath.row)
                sections[indexPath.section] = section
                return sections
            }
            .bind(to: languageSettingSection$)
            .disposed(by: disposeBag)
        
        itemMoved$
            .withLatestFrom(languageSettingSection$) { movedEvent, sections -> [LanguageSettingSection] in
                let sourceIndex = movedEvent.sourceIndex
                let destinationIndex = movedEvent.destinationIndex
                var sections = sections
                var section = sections[sourceIndex.section]
                section.items.move(fromOffsets: .init(integer: sourceIndex.row), toOffset: destinationIndex.row)
                sections[sourceIndex.section] = section
                return sections
            }
            .bind(to: languageSettingSection$)
            .disposed(by: disposeBag)
        
        editingDidBegin$
            .map { _ ->  LanguageSearchViewModel in
                let viewModel = LanguageSearchViewModel()
                viewModel.delegate = self
                return viewModel
            }
            .bind(to: showSearchView$)
            .disposed(by: disposeBag)
        
        selectedLanguage$
            .withLatestFrom(languageSettingSection$.map { $0.flatMap(\.items)}) { (language: $0, languages: $1) }
            .filter { !$0.languages.contains($0.language) }
            .map { $0.languages + [$0.language] }
            .withLatestFrom(languageSettingSection$) { languages, sections -> [LanguageSettingSection] in
                var sections = sections
                var section = sections[0]
                section.items = languages
                sections[0] = section
                return sections
            }
            .bind(to: languageSettingSection$)
            .disposed(by: disposeBag)
    }
}

// MARK: - LanguageSearchViewModelDelegate
extension LanguageSettingViewModel: LanguageSearchViewModelDelegate {
    func selectedLanguage(_ language: Language) {
        selectedLanguage$.onNext(language)
    }
}
