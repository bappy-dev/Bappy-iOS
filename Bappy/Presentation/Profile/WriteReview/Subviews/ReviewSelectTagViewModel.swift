//
//  ReviewSelectTagViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ReviewSelectTagViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var againButtonTapped: AnyObserver<Void> // <-> View
        var friendlyButtonTapped: AnyObserver<Void> // <-> View
        var respectfulButtonTapped: AnyObserver<Void> // <-> View
        var talkativeButtonTapped: AnyObserver<Void> // <-> View
        var punctualButtonTapped: AnyObserver<Void> // <-> View
        var rudeButtonTapped: AnyObserver<Void> // <-> View
        var notAgainButtonTapped: AnyObserver<Void> // <-> View
        var didntMeetButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var tags: Signal<[Reference.Tag]> // <-> Parent
        var isAgainButtonEnabled: Driver<Bool> // <-> View
        var isFriendlyButtonEnabled: Driver<Bool> // <-> View
        var isRespectfulButtonEnabled: Driver<Bool> // <-> View
        var isTalkativeButtonEnabled: Driver<Bool> // <-> View
        var isPunctualButtonEnabled: Driver<Bool> // <-> View
        var isRudeButtonEnabled: Driver<Bool> // <-> View
        var isNotAgainButtonEnabled: Driver<Bool> // <-> View
        var isDidntMeetButtonEnabled: Driver<Bool> // <-> View
        var isValid: Driver<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let tags$: BehaviorSubject<[Reference.Tag: Bool]>
    private let againButtonTapped$ = PublishSubject<Void>()
    private let friendlyButtonTapped$ = PublishSubject<Void>()
    private let respectfulButtonTapped$ = PublishSubject<Void>()
    private let talkativeButtonTapped$ = PublishSubject<Void>()
    private let punctualButtonTapped$ = PublishSubject<Void>()
    private let rudeButtonTapped$ = PublishSubject<Void>()
    private let notAgainButtonTapped$ = PublishSubject<Void>()
    private let didntMeetButtonTapped$ = PublishSubject<Void>()
    
    private let isAgainButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isFriendlyButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isRespectfulButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isTalkativeButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isPunctualButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isRudeButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isNotAgainButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isDidntMeetButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let tags$ = BehaviorSubject<[Reference.Tag: Bool]>(value: [:])
        
        let tags = tags$
            .map { $0.filter { $0.value } }
            .map { $0.map { $0.key } }
            .asSignal(onErrorJustReturn: [])
        
        let isAgainButtonEnabled = againButtonTapped$
            .withLatestFrom(isAgainButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isFriendlyButtonEnabled = friendlyButtonTapped$
            .withLatestFrom(isFriendlyButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isRespectfulButtonEnabled = respectfulButtonTapped$
            .withLatestFrom(isRespectfulButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isTalkativeButtonEnabled = talkativeButtonTapped$
            .withLatestFrom(isTalkativeButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isPunctualButtonEnabled = punctualButtonTapped$
            .withLatestFrom(isPunctualButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isRudeButtonEnabled = rudeButtonTapped$
            .withLatestFrom(isRudeButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isNotAgainButtonEnabled = notAgainButtonTapped$
            .withLatestFrom(isNotAgainButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isDidntMeetButtonEnabled = didntMeetButtonTapped$
            .withLatestFrom(isDidntMeetButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        
        let isValid = tags
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        
        
        // MARK: Input & Output
        self.input = Input(
            againButtonTapped: againButtonTapped$.asObserver(),
            friendlyButtonTapped: friendlyButtonTapped$.asObserver(),
            respectfulButtonTapped: respectfulButtonTapped$.asObserver(),
            talkativeButtonTapped: talkativeButtonTapped$.asObserver(),
            punctualButtonTapped: punctualButtonTapped$.asObserver(),
            rudeButtonTapped: rudeButtonTapped$.asObserver(),
            notAgainButtonTapped: notAgainButtonTapped$.asObserver(),
            didntMeetButtonTapped: didntMeetButtonTapped$.asObserver())
        
        self.output = Output(
            tags: tags,
            isAgainButtonEnabled: isAgainButtonEnabled,
            isFriendlyButtonEnabled: isFriendlyButtonEnabled,
            isRespectfulButtonEnabled: isRespectfulButtonEnabled,
            isTalkativeButtonEnabled: isTalkativeButtonEnabled,
            isPunctualButtonEnabled: isPunctualButtonEnabled,
            isRudeButtonEnabled: isRudeButtonEnabled,
            isNotAgainButtonEnabled: isNotAgainButtonEnabled,
            isDidntMeetButtonEnabled: isDidntMeetButtonEnabled,
            isValid: isValid)
        
        // MARK: Binding
        self.tags$ = tags$
        
        isAgainButtonEnabled
            .drive(isAgainButtonEnabled$)
            .disposed(by: disposeBag)
        isFriendlyButtonEnabled
            .drive(isFriendlyButtonEnabled$)
            .disposed(by: disposeBag)
        isRespectfulButtonEnabled
            .drive(isRespectfulButtonEnabled$)
            .disposed(by: disposeBag)
        isTalkativeButtonEnabled
            .drive(isTalkativeButtonEnabled$)
            .disposed(by: disposeBag)
        isPunctualButtonEnabled
            .drive(isPunctualButtonEnabled$)
            .disposed(by: disposeBag)
        isRudeButtonEnabled
            .drive(isRudeButtonEnabled$)
            .disposed(by: disposeBag)
        isNotAgainButtonEnabled
            .drive(isNotAgainButtonEnabled$)
            .disposed(by: disposeBag)
        isDidntMeetButtonEnabled
            .drive(isDidntMeetButtonEnabled$)
            .disposed(by: disposeBag)
        
        isAgainButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.Again] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isFriendlyButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.Friendly] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isRespectfulButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.Respectful] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isTalkativeButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.Talkative] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isPunctualButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.Punctual] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isRudeButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.Rude] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isNotAgainButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.NotAgain] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
        isDidntMeetButtonEnabled$
            .withLatestFrom(tags$) { isEnabled, dict -> [Reference.Tag: Bool] in
                var newDict = dict
                newDict[.DidntMeet] = isEnabled
                return newDict
            }
            .bind(to: tags$)
            .disposed(by: disposeBag)
    }
}
