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
        var interests: [HangoutCategory: Bool] {
            var dict = [HangoutCategory: Bool]()
            for personality in (user.interests ?? []) {
                dict[personality] = true
            }
            return dict
        }
    }
    
    struct Input {
        var travelButtonTapped$: AnyObserver<Void>
        var studyButtonTapped$: AnyObserver<Void>
        var sportsButtonTapped$: AnyObserver<Void>
        var foodButtonTapped$: AnyObserver<Void>
        var drinksButtonTapped$: AnyObserver<Void>
        var cookButtonTapped$: AnyObserver<Void>
        var cultureButtonTapped$: AnyObserver<Void>
        var volunteerButtonTapped$: AnyObserver<Void>
        var languageButtonTapped$: AnyObserver<Void>
        var craftingButtonTapped$: AnyObserver<Void>
    }
    
    struct Output {
        var travel: Driver<Bool>
        var study: Driver<Bool>
        var sports: Driver<Bool>
        var food: Driver<Bool>
        var drinks: Driver<Bool>
        var cook: Driver<Bool>
        var culture: Driver<Bool>
        var volunteer: Driver<Bool>
        var language: Driver<Bool>
        var crafting: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let interests$: BehaviorSubject<[HangoutCategory: Bool]>
    
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
        
        // Streams
        let interests$ = BehaviorSubject<[HangoutCategory: Bool]>(value: dependency.interests)
        
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
        
        // Input & Output
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
            crafting: crafting
        )
        
        // Bindind
        self.interests$ = interests$
        
        travelButtonTapped$
            .map { HangoutCategory.Travel }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        studyButtonTapped$
            .map { HangoutCategory.Study }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        sportsButtonTapped$
            .map { HangoutCategory.Sports }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        foodButtonTapped$
            .map { HangoutCategory.Food }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        drinksButtonTapped$
            .map { HangoutCategory.Drinks }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        cookButtonTapped$
            .map { HangoutCategory.Cook }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        cultureButtonTapped$
            .map { HangoutCategory.Culture }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        volunteerButtonTapped$
            .map { HangoutCategory.Volunteer }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        languageButtonTapped$
            .map { HangoutCategory.Language }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
        
        craftingButtonTapped$
            .map { HangoutCategory.Crafting }
            .withLatestFrom(interests$, resultSelector: flipInterestOfDict)
            .bind(to: interests$)
            .disposed(by: disposeBag)
    }
}

private func flipInterestOfDict(interest: HangoutCategory, in interests: [HangoutCategory: Bool]) -> [HangoutCategory: Bool] {
    var dict = interests
    dict[interest] = !(interests[interest] ?? false)
    return dict
}
