//
//  ProfileEditInterestsViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditInterestsViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var interests: [Hangout.Category: Bool] {
            var dict = [Hangout.Category: Bool]()
            for personality in (user.interests ?? []) {
                dict[personality] = true
            }
            return dict
        }
    }
    
    struct Input {
        var travelButtonTapped$: AnyObserver<Void> // <-> View
        var cafeButtonTapped$: AnyObserver<Void> // <-> View
        var hikingButtonTapped$: AnyObserver<Void> // <-> View
        var foodButtonTapped$: AnyObserver<Void> // <-> View
        var barButtonTapped$: AnyObserver<Void> // <-> View
        var cookButtonTapped$: AnyObserver<Void> // <-> View
        var shoppingButtonTapped$: AnyObserver<Void> // <-> View
        var volunteerButtonTapped$: AnyObserver<Void> // <-> View
        var languageButtonTapped$: AnyObserver<Void> // <-> View
        var craftingButtonTapped$: AnyObserver<Void> // <-> View
        var ballGameButtonTapped$: AnyObserver<Void>
        var concertsButtonTapped$: AnyObserver<Void>
        var museumButtonTapped$: AnyObserver<Void>
        var veganButtonTapped$: AnyObserver<Void>
        var boardgameButtonTapped$: AnyObserver<Void>
        var runningButtonTapped$: AnyObserver<Void>
        var musicButtonTapped$: AnyObserver<Void>
    }
    
    struct Output {
        var travel: Driver<Bool> // <-> View
        var cafe: Driver<Bool> // <-> View
        var hiking: Driver<Bool> // <-> View
        var food: Driver<Bool> // <-> View
        var bar: Driver<Bool> // <-> View
        var cook: Driver<Bool> // <-> View
        var shopping: Driver<Bool> // <-> View
        var volunteer: Driver<Bool> // <-> View
        var language: Driver<Bool> // <-> View
        var crafting: Driver<Bool> // <-> View
        var music: Driver<Bool>
        var ballgame: Driver<Bool>
        var vegan: Driver<Bool>
        var running: Driver<Bool>
        var concerts: Driver<Bool>
        var museum: Driver<Bool>
        var boardgame: Driver<Bool>
        var edittedInterests: Signal<[Hangout.Category]?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let interests$: BehaviorSubject<[Hangout.Category: Bool]>
    
    private let travelButtonTapped$ = PublishSubject<Void>()
    private let cafeButtonTapped$ = PublishSubject<Void>()
    private let hikingButtonTapped$ = PublishSubject<Void>()
    private let foodButtonTapped$ = PublishSubject<Void>()
    private let barButtonTapped$ = PublishSubject<Void>()
    private let cookButtonTapped$ = PublishSubject<Void>()
    private let shoppingButtonTapped$ = PublishSubject<Void>()
    private let volunteerButtonTapped$ = PublishSubject<Void>()
    private let languageButtonTapped$ = PublishSubject<Void>()
    private let craftingButtonTapped$ = PublishSubject<Void>()
    private let ballGameButtonTapped$ = PublishSubject<Void>()
    private let concertsButtonTapped$ = PublishSubject<Void>()
    private let museumButtonTapped$ = PublishSubject<Void>()
    private let veganButtonTapped$ = PublishSubject<Void>()
    private let boardgameButtonTapped$ = PublishSubject<Void>()
    private let runningButtonTapped$ = PublishSubject<Void>()
    private let musicButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let interests$ = BehaviorSubject<[Hangout.Category: Bool]>(value: dependency.interests)
        
        let travel = interests$
            .map { $0[.Travel] ?? false }
            .asDriver(onErrorJustReturn: false)
        let cafe = interests$
            .map { $0[.Cafe] ?? false }
            .asDriver(onErrorJustReturn: false)
        let hiking = interests$
            .map { $0[.Hiking] ?? false }
            .asDriver(onErrorJustReturn: false)
        let food = interests$
            .map { $0[.Food] ?? false }
            .asDriver(onErrorJustReturn: false)
        let bar = interests$
            .map { $0[.Bar] ?? false }
            .asDriver(onErrorJustReturn: false)
        let cook = interests$
            .map { $0[.Cook] ?? false }
            .asDriver(onErrorJustReturn: false)
        let shopping = interests$
            .map { $0[.Shopping] ?? false }
            .asDriver(onErrorJustReturn: false)
        let volunteer = interests$
            .map { $0[.Volunteer] ?? false }
            .asDriver(onErrorJustReturn: false)
        let language = interests$
            .map { $0[.Language] ?? false }
            .asDriver(onErrorJustReturn: false)
        let crafting = interests$
            .map { $0[.Crafting] ?? false }
            .asDriver(onErrorJustReturn: false)
        let boardgame = interests$
            .map { $0[.Boardgame] ?? false }
            .asDriver(onErrorJustReturn: false)
        let music = interests$
            .map { $0[.Music] ?? false }
            .asDriver(onErrorJustReturn: false)
        let ballgame = interests$
            .map { $0[.BallGame] ?? false }
            .asDriver(onErrorJustReturn: false)
        let vegan = interests$
            .map { $0[.Vegan] ?? false }
            .asDriver(onErrorJustReturn: false)
        let running = interests$
            .map { $0[.Running] ?? false }
            .asDriver(onErrorJustReturn: false)
        let concerts = interests$
            .map { $0[.Concerts] ?? false }
            .asDriver(onErrorJustReturn: false)
        let museum = interests$
            .map { $0[.Museum] ?? false }
            .asDriver(onErrorJustReturn: false)
        let edittedInterests = interests$
            .map { $0.filter(\.value) }
            .map { $0.map(\.key) }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            travelButtonTapped$: travelButtonTapped$.asObserver(),
            cafeButtonTapped$: cafeButtonTapped$.asObserver(),
            hikingButtonTapped$: hikingButtonTapped$.asObserver(),
            foodButtonTapped$: foodButtonTapped$.asObserver(),
            barButtonTapped$: barButtonTapped$.asObserver(),
            cookButtonTapped$: cookButtonTapped$.asObserver(),
            shoppingButtonTapped$: shoppingButtonTapped$.asObserver(),
            volunteerButtonTapped$: volunteerButtonTapped$.asObserver(),
            languageButtonTapped$: languageButtonTapped$.asObserver(),
            craftingButtonTapped$: craftingButtonTapped$.asObserver(),
            ballGameButtonTapped$: ballGameButtonTapped$.asObserver(),
            concertsButtonTapped$: concertsButtonTapped$.asObserver(),
            museumButtonTapped$: museumButtonTapped$.asObserver(),
            veganButtonTapped$: veganButtonTapped$.asObserver(),
            boardgameButtonTapped$: boardgameButtonTapped$.asObserver(),
            runningButtonTapped$: runningButtonTapped$.asObserver(),
            musicButtonTapped$: musicButtonTapped$.asObserver())
        
        self.output = Output(
            travel: travel,
            cafe: cafe,
            hiking: hiking,
            food: food,
            bar: bar,
            cook: cook,
            shopping: shopping,
            volunteer: volunteer,
            language: language,
            crafting: crafting,
            music: music,
            ballgame: ballgame,
            vegan: vegan,
            running: running,
            concerts: concerts,
            museum: museum,
            boardgame: boardgame,
            edittedInterests: edittedInterests)
        
        // MARK: Bindind
        self.interests$ = interests$
        
        travelButtonTapped$
            .map { Hangout.Category.Travel }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        cafeButtonTapped$
            .map { Hangout.Category.Cafe }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        hikingButtonTapped$
            .map { Hangout.Category.Hiking }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        foodButtonTapped$
            .map { Hangout.Category.Food }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        barButtonTapped$
            .map { Hangout.Category.Bar }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        cookButtonTapped$
            .map { Hangout.Category.Cook }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        shoppingButtonTapped$
            .map { Hangout.Category.Shopping }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        volunteerButtonTapped$
            .map { Hangout.Category.Volunteer }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        languageButtonTapped$
            .map { Hangout.Category.Language }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        craftingButtonTapped$
            .map { Hangout.Category.Crafting }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        musicButtonTapped$
            .map { Hangout.Category.Music }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        ballGameButtonTapped$
            .map { Hangout.Category.BallGame }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        veganButtonTapped$
            .map { Hangout.Category.Vegan }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        runningButtonTapped$
            .map { Hangout.Category.Running }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        concertsButtonTapped$
            .map { Hangout.Category.Concerts }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        museumButtonTapped$
            .map { Hangout.Category.Museum }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        boardgameButtonTapped$
            .map { Hangout.Category.Boardgame }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
    }
}

private func flipInterestOfDict(interest: Hangout.Category, in interests: [Hangout.Category: Bool]) -> [Hangout.Category: Bool] {
    var dict = interests
    dict[interest] = !(interests[interest] ?? false)
    return dict
}
