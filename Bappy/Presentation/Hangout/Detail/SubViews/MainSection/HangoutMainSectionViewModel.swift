//
//  HangoutMainSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMainSectionViewModel: ViewModelType {
    
    struct Dependency {
        var hangout: Hangout
        var isUserParticipating: Bool
        var title: String { hangout.title }
        var meetTime: String { hangout.meetTime }
        var language: Language { hangout.language }
        var placeName: String { hangout.placeName }
        var openchatURL: URL? { hangout.openchatURL }
    }
    
    struct Input {
        var openchatButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var title: Signal<String> // <-> View
        var meetTime: Signal<String> // <-> View
        var language: Signal<Language> // <-> View
        var placeName: Signal<String> // <-> View
        var shouldHideOpenchat: Driver<Bool> // <-> View
        var goOpenchat: Signal<URL?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let isUserParticipating$: BehaviorSubject<Bool>
    private let title$: BehaviorSubject<String>
    private let meetTime$: BehaviorSubject<String>
    private let language$: BehaviorSubject<Language>
    private let placeName$: BehaviorSubject<String>
    private let openchatURL$: BehaviorSubject<URL?>
    
    private let openchatButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let isUserParticipating$ = BehaviorSubject<Bool>(value: dependency.isUserParticipating)
        let title$ = BehaviorSubject<String>(value: dependency.title)
        let meetTime$ = BehaviorSubject<String>(value: dependency.meetTime)
        let language$ = BehaviorSubject<Language>(value: dependency.language)
        let placeName$ = BehaviorSubject<String>(value: dependency.placeName)
        let openchatURL$ = BehaviorSubject<URL?>(value: dependency.openchatURL)
        
        let title = title$
            .asSignal(onErrorJustReturn: dependency.title)
        let meetTime = meetTime$
            .asSignal(onErrorJustReturn: dependency.meetTime)
        let language = language$
            .asSignal(onErrorJustReturn: dependency.language)
        let placeName = placeName$
            .asSignal(onErrorJustReturn: dependency.placeName)
        let shouldHideOpenchat = isUserParticipating$
            .map { !$0 }
            .asDriver(onErrorJustReturn: !dependency.isUserParticipating)
        let goOpenchat = openchatButtonTapped$
            .withLatestFrom(openchatURL$)
            .asSignal(onErrorJustReturn: dependency.openchatURL)
        
        // MARK: Input & Output
        self.input = Input(
            openchatButtonTapped: openchatButtonTapped$.asObserver()
        )
        
        self.output = Output(
            title: title,
            meetTime: meetTime,
            language: language,
            placeName: placeName,
            shouldHideOpenchat: shouldHideOpenchat,
            goOpenchat: goOpenchat
        )
        
        // MARK: Bindind
        self.isUserParticipating$ = isUserParticipating$
        self.title$ = title$
        self.meetTime$ = meetTime$
        self.language$ = language$
        self.placeName$ = placeName$
        self.openchatURL$ = openchatURL$
    }
}
