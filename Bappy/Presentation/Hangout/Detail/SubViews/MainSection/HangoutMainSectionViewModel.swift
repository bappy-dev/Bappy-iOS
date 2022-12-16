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
        var meetTime: String {
            hangout.meetTime.toString(dateFormat: "dd. MMM. HH:mm")
        }
        var language: Language { hangout.language }
        var placeName: String { hangout.place.name }
        var openchatURL: String { hangout.openchatURL }
    }
    
    struct Input {
        var userParticipating: AnyObserver<Bool>
        var openchatButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var title: Signal<String> // <-> View
        var meetTime: Signal<String> // <-> View
        var language: Signal<Language> // <-> View
        var placeName: Signal<String> // <-> View
        var shouldHideOpenchat: Driver<Bool> // <-> View
        var isSelected: Signal<Bool>
        var goOpenchat: Signal<String> // <-> View
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
    private let isSelected$: BehaviorSubject<Bool>
    private let openchatURL$: BehaviorSubject<String>
    
    private let openchatButtonTapped$ = PublishSubject<Void>()
    private let userParticipating$ = PublishSubject<Bool>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let isUserParticipating$ = BehaviorSubject<Bool>(value: dependency.isUserParticipating)
        let title$ = BehaviorSubject<String>(value: dependency.title)
        let meetTime$ = BehaviorSubject<String>(value: dependency.meetTime)
        let language$ = BehaviorSubject<Language>(value: dependency.language)
        let placeName$ = BehaviorSubject<String>(value: dependency.placeName)
        let openchatURL$ = BehaviorSubject<String>(value: dependency.openchatURL)
        let isSelected$ = BehaviorSubject<Bool>(value: false)
        
        let title = title$
            .asSignal(onErrorJustReturn: dependency.title)
        let meetTime = meetTime$
            .asSignal(onErrorJustReturn: dependency.meetTime)
        let language = language$
            .asSignal(onErrorJustReturn: dependency.language)
        let placeName = placeName$
            .asSignal(onErrorJustReturn: dependency.placeName)
        let isSelected = openchatURL$
            .map { urlStr -> Bool in
                if urlStr.contains("https://open.kakao.com/o/") ||
                    urlStr.contains("https://zoom.us/") ||
                    urlStr.contains("https://meet.google.com/") ||
                    urlStr.contains("www.bappy.kr"),
                    let _ = URL(string: urlStr) {
                    return false
                } else {
                    return true
                }
            }.asSignal(onErrorJustReturn: true)
        let shouldHideOpenchat = userParticipating$
            .map { !$0 }
            .asDriver(onErrorJustReturn: !dependency.isUserParticipating)
            .startWith(!dependency.isUserParticipating)
        let goOpenchat = openchatButtonTapped$
            .withLatestFrom(openchatURL$)
            .asSignal(onErrorJustReturn: "")
        
        // MARK: Input & Output
        self.input = Input(
            userParticipating: userParticipating$.asObserver(),
            openchatButtonTapped: openchatButtonTapped$.asObserver()
        )
        
        self.output = Output(
            title: title,
            meetTime: meetTime,
            language: language,
            placeName: placeName,
            shouldHideOpenchat: shouldHideOpenchat,
            isSelected: isSelected,
            goOpenchat: goOpenchat
        )
        
        // MARK: Bindind
        self.isUserParticipating$ = isUserParticipating$
        self.title$ = title$
        self.meetTime$ = meetTime$
        self.language$ = language$
        self.placeName$ = placeName$
        self.openchatURL$ = openchatURL$
        self.isSelected$ = isSelected$
    }
}
