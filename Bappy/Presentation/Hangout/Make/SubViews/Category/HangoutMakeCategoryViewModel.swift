//
//  HangoutMakeCategoryViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeCategoryViewModel: ViewModelType {
    
    struct Dependency {
        let isStartWith: Bool
    }
    
    struct Input {
        var travelButtonTapped: AnyObserver<Void> // <-> View
        var cafeButtonTapped: AnyObserver<Void> // <-> View
        var hikingButtonTapped: AnyObserver<Void> // <-> View
        var foodButtonTapped: AnyObserver<Void> // <-> View
        var barButtonTapped: AnyObserver<Void> // <-> View
        var cookButtonTapped: AnyObserver<Void> // <-> View
        var shoppingButtonTapped: AnyObserver<Void> // <-> View
        var volunteerButtonTapped: AnyObserver<Void> // <-> View
        var languageButtonTapped: AnyObserver<Void> // <-> View
        var craftingButtonTapped: AnyObserver<Void> // <-> View
        var ballGameButtonTapped: AnyObserver<Void>
        var concertsButtonTapped: AnyObserver<Void>
        var museumButtonTapped: AnyObserver<Void>
        var veganButtonTapped: AnyObserver<Void>
        var boardgameButtonTapped: AnyObserver<Void>
        var runningButtonTapped: AnyObserver<Void>
        var musicButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var categories: Signal<[Hangout.Category]> // <-> Parent
        var isTravelButtonEnabled: Driver<Bool> // <-> View
        var isCafeButtonEnabled: Driver<Bool> // <-> View
        var isHikingButtonEnabled: Driver<Bool> // <-> View
        var isFoodButtonEnabled: Driver<Bool> // <-> View
        var isBarButtonEnabled: Driver<Bool> // <-> View
        var isCookButtonEnabled: Driver<Bool> // <-> View
        var isShoppingButtonEnabled: Driver<Bool> // <-> View
        var isVolunteerButtonEnabled: Driver<Bool> // <-> View
        var isLanguageButtonEnabled: Driver<Bool> // <-> View
        var isCraftingButtonEnabled: Driver<Bool> // <-> View
        var ballGameButtonEnabled: Driver<Bool>
        var concertsButtonEnabled: Driver<Bool>
        var museumButtonEnabled: Driver<Bool>
        var veganButtonEnabled: Driver<Bool>
        var boardgameButtonEnabled: Driver<Bool>
        var runningButtonEnabled: Driver<Bool>
        var musicButtonEnabled: Driver<Bool>
        var shouldHideRule: Driver<Bool> // <-> View
        var isValid: Driver<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let categories$: BehaviorSubject<[Hangout.Category: Bool]>
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
    
    private let isTravelButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isCafeButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isHikingButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isFoodButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isBarButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isCookButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isShoppingButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isVolunteerButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isLanguageButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isCraftingButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isBallGameButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isConcertsButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isMuseumButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isVeganButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isBoardgameButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isRunningButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isMusicButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency = Dependency(isStartWith: false)) {
        self.dependency = dependency
        
        // MARK: Streams
        let categories$ = BehaviorSubject<[Hangout.Category: Bool]>(value: [:])
        
        let categories = categories$
            .map { $0.filter { $0.value } }
            .map { $0.map { $0.key } }
            .asSignal(onErrorJustReturn: [])
        
        let isTravelButtonEnabled = travelButtonTapped$
            .withLatestFrom(isTravelButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isCafeButtonEnabled = cafeButtonTapped$
            .withLatestFrom(isCafeButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isHikingButtonEnabled = hikingButtonTapped$
            .withLatestFrom(isHikingButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isFoodButtonEnabled = foodButtonTapped$
            .withLatestFrom(isFoodButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isBarButtonEnabled = barButtonTapped$
            .withLatestFrom(isBarButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isCookButtonEnabled = cookButtonTapped$
            .withLatestFrom(isCookButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isShoppingButtonEnabled = shoppingButtonTapped$
            .withLatestFrom(isShoppingButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isVolunteerButtonEnabled = volunteerButtonTapped$
            .withLatestFrom(isVolunteerButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isLanguageButtonEnabled = languageButtonTapped$
            .withLatestFrom(isLanguageButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isCraftingButtonEnabled = craftingButtonTapped$
            .withLatestFrom(isCraftingButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isBallGameButtonEnabled = ballGameButtonTapped$
            .withLatestFrom(isBallGameButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isVeganButtonEnabled = veganButtonTapped$
            .withLatestFrom(isVeganButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isRunningButtonEnabled = runningButtonTapped$
            .withLatestFrom(isRunningButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isMusicButtonEnabled = musicButtonTapped$
            .withLatestFrom(isMusicButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isConcertsButtonEnabled = concertsButtonTapped$
            .withLatestFrom(isConcertsButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isMuseumButtonEnabled = museumButtonTapped$
            .withLatestFrom(isMuseumButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isBoardgameButtonEnabled = boardgameButtonTapped$
            .withLatestFrom(isBoardgameButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        
        let shouldHideRule = categories
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let isValid = shouldHideRule
        
        // MARK: Input & Output
        self.input = Input(
            travelButtonTapped: travelButtonTapped$.asObserver(),
            cafeButtonTapped: cafeButtonTapped$.asObserver(),
            hikingButtonTapped: hikingButtonTapped$.asObserver(),
            foodButtonTapped: foodButtonTapped$.asObserver(),
            barButtonTapped: barButtonTapped$.asObserver(),
            cookButtonTapped: cookButtonTapped$.asObserver(),
            shoppingButtonTapped: shoppingButtonTapped$.asObserver(),
            volunteerButtonTapped: volunteerButtonTapped$.asObserver(),
            languageButtonTapped: languageButtonTapped$.asObserver(),
            craftingButtonTapped: craftingButtonTapped$.asObserver(),
            ballGameButtonTapped: ballGameButtonTapped$.asObserver(),
            concertsButtonTapped: concertsButtonTapped$.asObserver(),
            museumButtonTapped: museumButtonTapped$.asObserver(),
            veganButtonTapped: veganButtonTapped$.asObserver(),
            boardgameButtonTapped: boardgameButtonTapped$.asObserver(),
            runningButtonTapped: runningButtonTapped$.asObserver(),
            musicButtonTapped: musicButtonTapped$.asObserver())
        
        self.output = Output(
            categories: categories,
            isTravelButtonEnabled: isTravelButtonEnabled,
            isCafeButtonEnabled: isCafeButtonEnabled,
            isHikingButtonEnabled: isHikingButtonEnabled,
            isFoodButtonEnabled: isFoodButtonEnabled,
            isBarButtonEnabled: isBarButtonEnabled,
            isCookButtonEnabled: isCookButtonEnabled,
            isShoppingButtonEnabled: isShoppingButtonEnabled,
            isVolunteerButtonEnabled: isVolunteerButtonEnabled,
            isLanguageButtonEnabled: isLanguageButtonEnabled,
            isCraftingButtonEnabled: isCraftingButtonEnabled,
            ballGameButtonEnabled: isBallGameButtonEnabled,
            concertsButtonEnabled: isConcertsButtonEnabled,
            museumButtonEnabled: isMuseumButtonEnabled,
            veganButtonEnabled: isVeganButtonEnabled,
            boardgameButtonEnabled: isBoardgameButtonEnabled,
            runningButtonEnabled: isRunningButtonEnabled,
            musicButtonEnabled: isMusicButtonEnabled,
            shouldHideRule: shouldHideRule,
            isValid: isValid)
        
        // MARK: Binding
        self.categories$ = categories$
        
        isTravelButtonEnabled
            .drive(isTravelButtonEnabled$)
            .disposed(by: disposeBag)
        isCafeButtonEnabled
            .drive(isCafeButtonEnabled$)
            .disposed(by: disposeBag)
        isHikingButtonEnabled
            .drive(isHikingButtonEnabled$)
            .disposed(by: disposeBag)
        isFoodButtonEnabled
            .drive(isFoodButtonEnabled$)
            .disposed(by: disposeBag)
        isBarButtonEnabled
            .drive(isBarButtonEnabled$)
            .disposed(by: disposeBag)
        isCookButtonEnabled
            .drive(isCookButtonEnabled$)
            .disposed(by: disposeBag)
        isShoppingButtonEnabled
            .drive(isShoppingButtonEnabled$)
            .disposed(by: disposeBag)
        isVolunteerButtonEnabled
            .drive(isVolunteerButtonEnabled$)
            .disposed(by: disposeBag)
        isLanguageButtonEnabled
            .drive(isLanguageButtonEnabled$)
            .disposed(by: disposeBag)
        isCraftingButtonEnabled
            .drive(isCraftingButtonEnabled$)
            .disposed(by: disposeBag)
        isMusicButtonEnabled
            .drive(isMusicButtonEnabled$)
            .disposed(by: disposeBag)
        isBallGameButtonEnabled
            .drive(isBallGameButtonEnabled$)
            .disposed(by: disposeBag)
        isVeganButtonEnabled
            .drive(isVeganButtonEnabled$)
            .disposed(by: disposeBag)
        isRunningButtonEnabled
            .drive(isRunningButtonEnabled$)
            .disposed(by: disposeBag)
        isConcertsButtonEnabled
            .drive(isConcertsButtonEnabled$)
            .disposed(by: disposeBag)
        isMuseumButtonEnabled
            .drive(isMuseumButtonEnabled$)
            .disposed(by: disposeBag)
        isBoardgameButtonEnabled
            .drive(isBoardgameButtonEnabled$)
            .disposed(by: disposeBag)
        
        isTravelButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Travel] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isCafeButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Cafe] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isHikingButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Hiking] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isFoodButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Food] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isBarButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Bar] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isCookButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Cook] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isShoppingButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Shopping] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isVolunteerButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Volunteer] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isLanguageButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Language] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isCraftingButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Crafting] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isMusicButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Music] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isBallGameButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.BallGame] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isVeganButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Vegan] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isRunningButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Running] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isConcertsButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Concerts] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isMuseumButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Museum] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isBoardgameButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [Hangout.Category: Bool] in
                var newDict = dict
                newDict[.Boardgame] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
    }
}
