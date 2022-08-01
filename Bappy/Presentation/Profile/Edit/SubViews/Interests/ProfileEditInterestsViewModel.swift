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
        var studyButtonTapped$: AnyObserver<Void> // <-> View
        var sportsButtonTapped$: AnyObserver<Void> // <-> View
        var foodButtonTapped$: AnyObserver<Void> // <-> View
        var drinksButtonTapped$: AnyObserver<Void> // <-> View
        var cookButtonTapped$: AnyObserver<Void> // <-> View
        var cultureButtonTapped$: AnyObserver<Void> // <-> View
        var volunteerButtonTapped$: AnyObserver<Void> // <-> View
        var languageButtonTapped$: AnyObserver<Void> // <-> View
        var craftingButtonTapped$: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var travel: Driver<Bool> // <-> View
        var study: Driver<Bool> // <-> View
        var sports: Driver<Bool> // <-> View
        var food: Driver<Bool> // <-> View
        var drinks: Driver<Bool> // <-> View
        var cook: Driver<Bool> // <-> View
        var culture: Driver<Bool> // <-> View
        var volunteer: Driver<Bool> // <-> View
        var language: Driver<Bool> // <-> View
        var crafting: Driver<Bool> // <-> View
        var edittedInterests: Signal<[Hangout.Category]?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let interests$: BehaviorSubject<[Hangout.Category: Bool]>
    
    private let travelButtonTapped$ = PublishSubject<Void>()
    private let studyButtonTapped$ = PublishSubject<Void>()
    private let sportsButtonTapped$ = PublishSubject<Void>()
    private let foodButtonTapped$ = PublishSubject<Void>()
    private let drinksButtonTapped$ = PublishSubject<Void>()
    private let cookButtonTapped$ = PublishSubject<Void>()
    private let cultureButtonTapped$ = PublishSubject<Void>()
    private let volunteerButtonTapped$ = PublishSubject<Void>()
    private let languageButtonTapped$ = PublishSubject<Void>()
    private let craftingButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let interests$ = BehaviorSubject<[Hangout.Category: Bool]>(value: dependency.interests)
        
        let travel = interests$
            .map { $0[.Travel] ?? false }
            .asDriver(onErrorJustReturn: false)
        let study = interests$
            .map { $0[.Study] ?? false }
            .asDriver(onErrorJustReturn: false)
        let sports = interests$
            .map { $0[.Sports] ?? false }
            .asDriver(onErrorJustReturn: false)
        let food = interests$
            .map { $0[.Food] ?? false }
            .asDriver(onErrorJustReturn: false)
        let drinks = interests$
            .map { $0[.Drinks] ?? false }
            .asDriver(onErrorJustReturn: false)
        let cook = interests$
            .map { $0[.Cook] ?? false }
            .asDriver(onErrorJustReturn: false)
        let culture = interests$
            .map { $0[.Culture] ?? false }
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
        let edittedInterests = interests$
            .map { $0.filter(\.value) }
            .map { $0.map(\.key) }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            travelButtonTapped$: travelButtonTapped$.asObserver(),
            studyButtonTapped$: studyButtonTapped$.asObserver(),
            sportsButtonTapped$: sportsButtonTapped$.asObserver(),
            foodButtonTapped$: foodButtonTapped$.asObserver(),
            drinksButtonTapped$: drinksButtonTapped$.asObserver(),
            cookButtonTapped$: cookButtonTapped$.asObserver(),
            cultureButtonTapped$: cultureButtonTapped$.asObserver(),
            volunteerButtonTapped$: volunteerButtonTapped$.asObserver(),
            languageButtonTapped$: languageButtonTapped$.asObserver(),
            craftingButtonTapped$: craftingButtonTapped$.asObserver()
        )
        
        self.output = Output(
            travel: travel,
            study: study,
            sports: sports,
            food: food,
            drinks: drinks,
            cook: cook,
            culture: culture,
            volunteer: volunteer,
            language: language,
            crafting: crafting,
            edittedInterests: edittedInterests
        )
        
        // MARK: Bindind
        self.interests$ = interests$
        
        travelButtonTapped$
            .map { Hangout.Category.Travel }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        studyButtonTapped$
            .map { Hangout.Category.Study }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        sportsButtonTapped$
            .map { Hangout.Category.Sports }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        foodButtonTapped$
            .map { Hangout.Category.Food }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        drinksButtonTapped$
            .map { Hangout.Category.Drinks }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        cookButtonTapped$
            .map { Hangout.Category.Cook }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        cultureButtonTapped$
            .map { Hangout.Category.Culture }
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
    }
}

private func flipInterestOfDict(interest: Hangout.Category, in interests: [Hangout.Category: Bool]) -> [Hangout.Category: Bool] {
    var dict = interests
    dict[interest] = !(interests[interest] ?? false)
    return dict
}
