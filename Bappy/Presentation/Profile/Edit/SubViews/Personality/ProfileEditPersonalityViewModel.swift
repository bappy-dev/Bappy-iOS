//
//  ProfileEditPersonalityViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditPersonalityViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var personalities: [Persnoality: Bool] {
            var dict = [Persnoality: Bool]()
            for personality in (user.personalities ?? []) {
                dict[personality] = true
            }
            return dict
        }
    }
    
    struct Input {
        var spontaneousButtonTapped: AnyObserver<Void> // <-> View
        var planningButtonTapped: AnyObserver<Void> // <-> View
        var talkativeButtonTapped: AnyObserver<Void> // <-> View
        var empathicButtonTapped: AnyObserver<Void> // <-> View
        var shyButtonTapped: AnyObserver<Void> // <-> View
        var calmButtonTapped: AnyObserver<Void> // <-> View
        var politeButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var spontaneous: Driver<Bool> // <-> View
        var planning: Driver<Bool> // <-> View
        var talkative: Driver<Bool> // <-> View
        var empathic: Driver<Bool> // <-> View
        var shy: Driver<Bool> // <-> View
        var calm: Driver<Bool> // <-> View
        var polite: Driver<Bool> // <-> View
        var edittedPersonalities: Signal<[Persnoality]?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let personalities$: BehaviorSubject<[Persnoality: Bool]>
    
    private let spontaneousButtonTapped$ = PublishSubject<Void>()
    private let planningButtonTapped$ = PublishSubject<Void>()
    private let talkativeButtonTapped$ = PublishSubject<Void>()
    private let empathicButtonTapped$ = PublishSubject<Void>()
    private let shyButtonTapped$ = PublishSubject<Void>()
    private let calmButtonTapped$ = PublishSubject<Void>()
    private let politeButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let personalities$ = BehaviorSubject<[Persnoality: Bool]>(value: dependency.personalities)
        
        let spontaneous = personalities$
            .map { $0[.Spontaneous] ?? false }
            .asDriver(onErrorJustReturn: false)
        let planning = personalities$
            .map { $0[.Planning] ?? false }
            .asDriver(onErrorJustReturn: false)
        let talkative = personalities$
            .map { $0[.Talkative] ?? false }
            .asDriver(onErrorJustReturn: false)
        let empathic = personalities$
            .map { $0[.Empathatic] ?? false }
            .asDriver(onErrorJustReturn: false)
        let shy = personalities$
            .map { $0[.Shy] ?? false }
            .asDriver(onErrorJustReturn: false)
        let calm = personalities$
            .map { $0[.Calm] ?? false }
            .asDriver(onErrorJustReturn: false)
        let polite = personalities$
            .map { $0[.Polite] ?? false }
            .asDriver(onErrorJustReturn: false)
        let edittedPersonalities = personalities$
            .map { $0.filter(\.value) }
            .map { $0.map(\.key) }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            spontaneousButtonTapped: spontaneousButtonTapped$.asObserver(),
            planningButtonTapped: planningButtonTapped$.asObserver(),
            talkativeButtonTapped: talkativeButtonTapped$.asObserver(),
            empathicButtonTapped: empathicButtonTapped$.asObserver(),
            shyButtonTapped: shyButtonTapped$.asObserver(),
            calmButtonTapped: calmButtonTapped$.asObserver(),
            politeButtonTapped: politeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            spontaneous: spontaneous,
            planning: planning,
            talkative: talkative,
            empathic: empathic,
            shy: shy,
            calm: calm,
            polite: polite,
            edittedPersonalities: edittedPersonalities
        )
        
        // MARK: Bindind
        self.personalities$ = personalities$
        
        spontaneousButtonTapped$
            .map { Persnoality.Spontaneous }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)

        planningButtonTapped$
            .map { Persnoality.Planning }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)
        
        talkativeButtonTapped$
            .map { Persnoality.Talkative }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)
        
        empathicButtonTapped$
            .map { Persnoality.Empathatic }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)
        
        shyButtonTapped$
            .map { Persnoality.Shy }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)
        
        calmButtonTapped$
            .map { Persnoality.Calm }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)
        
        politeButtonTapped$
            .map { Persnoality.Polite }
            .withLatestFrom(personalities$, resultSelector: flipPersonalityOfDict)
            .bind(to: personalities$)
            .disposed(by: disposeBag)
    }
}

private func flipPersonalityOfDict(personality: Persnoality, in personalities: [Persnoality: Bool]) -> [Persnoality: Bool] {
    var dict = personalities
    dict[personality] = !(personalities[personality] ?? false)
    return dict
}
