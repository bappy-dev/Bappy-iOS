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
    struct Dependency {}
    
    struct Input {
        var categories: AnyObserver<[HangoutCategory: Bool]>
        var travelButtonTapped: AnyObserver<Void>
        var studyButtonTapped: AnyObserver<Void>
        var sportsButtonTapped: AnyObserver<Void>
        var foodButtonTapped: AnyObserver<Void>
        var drinksButtonTapped: AnyObserver<Void>
        var cookButtonTapped: AnyObserver<Void>
        var cultureButtonTapped: AnyObserver<Void>
        var volunteerButtonTapped: AnyObserver<Void>
        var languageButtonTapped: AnyObserver<Void>
        var craftingButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var categories: Signal<[HangoutCategory]>
        var isTravelButtonEnabled: Driver<Bool>
        var isStudyButtonEnabled: Driver<Bool>
        var isSportsButtonEnabled: Driver<Bool>
        var isFoodButtonEnabled: Driver<Bool>
        var isDrinksButtonEnabled: Driver<Bool>
        var isCookButtonEnabled: Driver<Bool>
        var isCultureButtonEnabled: Driver<Bool>
        var isVolunteerButtonEnabled: Driver<Bool>
        var isLanguageButtonEnabled: Driver<Bool>
        var isCraftingButtonEnabled: Driver<Bool>
        var shouldHideRule: Driver<Bool>
        var isValid: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let categories$: BehaviorSubject<[HangoutCategory: Bool]>
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
    
    private let isTravelButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isStudyButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isSportsButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isFoodButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isDrinksButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isCookButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isCultureButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isVolunteerButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isLanguageButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isCraftingButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let categories$ = BehaviorSubject<[HangoutCategory: Bool]>(value: [:])
        
        let categories = categories$
            .map { $0.filter { $0.value } }
            .map { $0.map { $0.key } }
            .asSignal(onErrorJustReturn: [])
        
        let isTravelButtonEnabled = travelButtonTapped$
            .withLatestFrom(isTravelButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isStudyButtonEnabled = studyButtonTapped$
            .withLatestFrom(isStudyButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isSportsButtonEnabled = sportsButtonTapped$
            .withLatestFrom(isSportsButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isFoodButtonEnabled = foodButtonTapped$
            .withLatestFrom(isFoodButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isDrinksButtonEnabled = drinksButtonTapped$
            .withLatestFrom(isDrinksButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isCookButtonEnabled = cookButtonTapped$
            .withLatestFrom(isCookButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isCultureButtonEnabled = cultureButtonTapped$
            .withLatestFrom(isCultureButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isVolunteerButtonEnabled = volunteerButtonTapped$
            .withLatestFrom(isVolunteerButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isLanguageButtonEnabled = languageButtonTapped$
            .withLatestFrom(isLanguageButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isCraftingButtonEnabled = craftingButtonTapped$
            .withLatestFrom(isCraftingButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let shouldHideRule = categories
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isValid = shouldHideRule
            
        
        // Input & Output
        self.input = Input(
            categories: categories$.asObserver(),
            travelButtonTapped: travelButtonTapped$.asObserver(),
            studyButtonTapped: studyButtonTapped$.asObserver(),
            sportsButtonTapped: sportsButtonTapped$.asObserver(),
            foodButtonTapped: foodButtonTapped$.asObserver(),
            drinksButtonTapped: drinksButtonTapped$.asObserver(),
            cookButtonTapped: cookButtonTapped$.asObserver(),
            cultureButtonTapped: cultureButtonTapped$.asObserver(),
            volunteerButtonTapped: volunteerButtonTapped$.asObserver(),
            languageButtonTapped: languageButtonTapped$.asObserver(),
            craftingButtonTapped: craftingButtonTapped$.asObserver()
        )
        
        self.output = Output(
            categories: categories,
            isTravelButtonEnabled: isTravelButtonEnabled,
            isStudyButtonEnabled: isStudyButtonEnabled,
            isSportsButtonEnabled: isSportsButtonEnabled,
            isFoodButtonEnabled: isFoodButtonEnabled,
            isDrinksButtonEnabled: isDrinksButtonEnabled,
            isCookButtonEnabled: isCookButtonEnabled,
            isCultureButtonEnabled: isCultureButtonEnabled,
            isVolunteerButtonEnabled: isVolunteerButtonEnabled,
            isLanguageButtonEnabled: isLanguageButtonEnabled,
            isCraftingButtonEnabled: isCraftingButtonEnabled,
            shouldHideRule: shouldHideRule,
            isValid: isValid
        )
        
        // Binding
        self.categories$ = categories$
        
        isTravelButtonEnabled
            .drive(isTravelButtonEnabled$)
            .disposed(by: disposeBag)
        isStudyButtonEnabled
            .drive(isStudyButtonEnabled$)
            .disposed(by: disposeBag)
        isSportsButtonEnabled
            .drive(isSportsButtonEnabled$)
            .disposed(by: disposeBag)
        isFoodButtonEnabled
            .drive(isFoodButtonEnabled$)
            .disposed(by: disposeBag)
        isDrinksButtonEnabled
            .drive(isDrinksButtonEnabled$)
            .disposed(by: disposeBag)
        isCookButtonEnabled
            .drive(isCookButtonEnabled$)
            .disposed(by: disposeBag)
        isCultureButtonEnabled
            .drive(isCultureButtonEnabled$)
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
        
        isTravelButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.travel] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isStudyButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.study] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isSportsButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.sports] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isFoodButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.food] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isDrinksButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.drinks] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isCookButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.cook] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isCultureButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.culture] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isVolunteerButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.volunteer] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isLanguageButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.language] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
        isCraftingButtonEnabled$
            .withLatestFrom(categories$) { isEnabled, dict -> [HangoutCategory: Bool] in
                var newDict = dict
                newDict[.crafting] = isEnabled
                return newDict
            }
            .bind(to: categories$)
            .disposed(by: disposeBag)
    }
}
