//
//  CategoryViewModel.swift
//  Bappy
//
//  Created by 이현욱 on 2022/12/10.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryViewModel: ViewModelType {
    
    struct Dependency {
        let categories: [Hangout.Category]
        var isStartWith: Bool = false
        var isEnabled: Bool = true
        var isSmall: Bool = false
    }
    
    struct Input {
        var travelButtonTapped: AnyObserver<Void> // <-> View
        var eat_outButtonTapped: AnyObserver<Void> // <-> View
        var cafeButtonTapped: AnyObserver<Void> // <-> View
        var cookingButtonTapped: AnyObserver<Void> // <-> View
        var veganButtonTapped: AnyObserver<Void>
        var barButtonTapped: AnyObserver<Void> // <-> View
        
        var languageButtonTapped: AnyObserver<Void> // <-> View
        var discussionButtonTapped: AnyObserver<Void> // <-> View
        var danceButtonTapped: AnyObserver<Void> // <-> View
        var kpopButtonTapped: AnyObserver<Void> // <-> View
        var studyButtonTapped: AnyObserver<Void> // <-> View
        var readButtonTapped: AnyObserver<Void> // <-> View
        var instrumentsButtonTapped: AnyObserver<Void> // <-> View
        var drawButtonTapped: AnyObserver<Void> // <-> View
        
        var movieButtonTapped: AnyObserver<Void> // <-> View
        var exhibitionButtonTapped: AnyObserver<Void> // <-> View
        var museumButtonTapped: AnyObserver<Void>
        var festivalButtonTapped: AnyObserver<Void>
        var concertsButtonTapped: AnyObserver<Void>
        var partyButtonTapped: AnyObserver<Void>
        var picnicButtonTapped: AnyObserver<Void>
        var boardgameButtonTapped: AnyObserver<Void>
        var sportsButtonTapped: AnyObserver<Void> // <-> View
        
        var volunteerButtonTapped: AnyObserver<Void>
        var projcetsButtonTapped: AnyObserver<Void>
        var careerButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var categories: Signal<[Hangout.Category]>
        var travel: Driver<Bool>
        var eat_out: Driver<Bool>
        var cafe: Driver<Bool>
        var cooking: Driver<Bool>
        var vegan: Driver<Bool>
        var bar: Driver<Bool>
        
        var language: Driver<Bool>
        var discussion: Driver<Bool>
        var dance: Driver<Bool>
        var kpop: Driver<Bool>
        var study: Driver<Bool>
        var read: Driver<Bool>
        var instruments: Driver<Bool>
        var draw: Driver<Bool>
        
        var movie: Driver<Bool>
        var exhibition: Driver<Bool>
        var museum: Driver<Bool>
        var festival: Driver<Bool>
        var concerts: Driver<Bool>
        var party: Driver<Bool>
        var picnic: Driver<Bool>
        var boardgame: Driver<Bool>
        var sports: Driver<Bool>
        
        var volunteer: Driver<Bool>
        var projcets: Driver<Bool>
        var career: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let categories$: BehaviorSubject<[Hangout.Category: Bool]>
    
    private let travelButtonTapped$ = PublishSubject<Void>()
    private let eat_outButtonTapped$ = PublishSubject<Void>()
    private let cafeButtonTapped$ = PublishSubject<Void>()
    private let cookingButtonTapped$ = PublishSubject<Void>()
    private let veganButtonTapped$ = PublishSubject<Void>()
    private let barButtonTapped$ = PublishSubject<Void>()
    
    private let languageButtonTapped$ = PublishSubject<Void>()
    private let discussionButtonTapped$ = PublishSubject<Void>()
    private let danceButtonTapped$ = PublishSubject<Void>()
    private let kpopButtonTapped$ = PublishSubject<Void>()
    private let studyButtonTapped$ = PublishSubject<Void>()
    private let readButtonTapped$ = PublishSubject<Void>()
    private let instrumentsButtonTapped$ = PublishSubject<Void>()
    private let drawButtonTapped$ = PublishSubject<Void>()
    private let movieButtonTapped$ = PublishSubject<Void>()
    private let exhibitionButtonTapped$ = PublishSubject<Void>()
    private let museumButtonTapped$ = PublishSubject<Void>()
    private let festivalButtonTapped$ = PublishSubject<Void>()
    private let concertsButtonTapped$ = PublishSubject<Void>()
    private let partyButtonTapped$ = PublishSubject<Void>()
    private let picnicButtonTapped$ = PublishSubject<Void>()
    private let boardgameButtonTapped$ = PublishSubject<Void>()
    private let sportsButtonTapped$ = PublishSubject<Void>()
    
    private let volunteerButtonTapped$ = PublishSubject<Void>()
    private let projcetsButtonTapped$ = PublishSubject<Void>()
    private let careerButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        var arrayToDictionary = Dictionary(uniqueKeysWithValues: dependency.categories.map { ($0, true) })
        
        if dependency.isStartWith {
            arrayToDictionary = Dictionary(uniqueKeysWithValues: Hangout.Category.allCases.map { ($0, true) })
            arrayToDictionary[.ALL] = nil
        }
        
        let categories$ = BehaviorSubject<[Hangout.Category: Bool]>(value: arrayToDictionary)
        
        let travel = categories$
            .map { $0[.Travel] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let cafe = categories$
            .map { $0[.Cafe] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let eat_out = categories$
            .map { $0[.Eat_out] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let vegan = categories$
            .map { $0[.Vegan] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let bar = categories$
            .map { $0[.Bar] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let cooking = categories$
            .map { $0[.Cooking] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let language = categories$
            .map { $0[.Language] ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(dependency.isStartWith)
        let discussion = categories$
            .map { $0[.Discussion] ?? false }
            .asDriver(onErrorJustReturn: false)
        let dance = categories$
            .map { $0[.Dance] ?? false }
            .asDriver(onErrorJustReturn: false)
        let kpop = categories$
            .map { $0[.KPOP] ?? false }
            .asDriver(onErrorJustReturn: false)
        let study = categories$
            .map { $0[.Study] ?? false }
            .asDriver(onErrorJustReturn: false)
        let read = categories$
            .map { $0[.Read] ?? false }
            .asDriver(onErrorJustReturn: false)
        let instruments = categories$
            .map { $0[.Instruments] ?? false }
            .asDriver(onErrorJustReturn: false)
        let draw = categories$
            .map { $0[.Draw] ?? false }
            .asDriver(onErrorJustReturn: false)
        let movie = categories$
            .map { $0[.Movie] ?? false }
            .asDriver(onErrorJustReturn: false)
        let exhibition = categories$
            .map { $0[.Exhibition] ?? false }
            .asDriver(onErrorJustReturn: false)
        let museum = categories$
            .map { $0[.Museum] ?? false }
            .asDriver(onErrorJustReturn: false)
        let festival = categories$
            .map { $0[.Festival] ?? false }
            .asDriver(onErrorJustReturn: false)
        let concerts = categories$
            .map { $0[.Concerts] ?? false }
            .asDriver(onErrorJustReturn: false)
        let party = categories$
            .map { $0[.Party] ?? false }
            .asDriver(onErrorJustReturn: false)
        let picnic = categories$
            .map { $0[.Picnic] ?? false }
            .asDriver(onErrorJustReturn: false)
        let boardgame = categories$
            .map { $0[.Boardgame] ?? false }
            .asDriver(onErrorJustReturn: false)
        let sports = categories$
            .map { $0[.Sports] ?? false }
            .asDriver(onErrorJustReturn: false)
        let volunteer = categories$
            .map { $0[.Volunteer] ?? false }
            .asDriver(onErrorJustReturn: false)
        let career = categories$
            .map { $0[.Career] ?? false }
            .asDriver(onErrorJustReturn: false)
        let projcets = categories$
            .map { $0[.Projcets] ?? false }
            .asDriver(onErrorJustReturn: false)
        let categories = categories$
            .map { $0.filter { $0.value } }
            .map { $0.map { $0.key } }
            .asSignal(onErrorJustReturn: [])
        
        // MARK: Input & Output
        self.input = Input(travelButtonTapped: travelButtonTapped$.asObserver(),
                           eat_outButtonTapped: eat_outButtonTapped$.asObserver(),
                           cafeButtonTapped: cafeButtonTapped$.asObserver(),
                           cookingButtonTapped: cookingButtonTapped$.asObserver(),
                           veganButtonTapped: veganButtonTapped$.asObserver(),
                           barButtonTapped: barButtonTapped$.asObserver(),
                           languageButtonTapped: languageButtonTapped$.asObserver(),
                           discussionButtonTapped: discussionButtonTapped$.asObserver(),
                           danceButtonTapped: danceButtonTapped$.asObserver(),
                           kpopButtonTapped: kpopButtonTapped$.asObserver(),
                           studyButtonTapped: studyButtonTapped$.asObserver(),
                           readButtonTapped: readButtonTapped$.asObserver(),
                           instrumentsButtonTapped: instrumentsButtonTapped$.asObserver(),
                           drawButtonTapped: drawButtonTapped$.asObserver(),
                           movieButtonTapped: movieButtonTapped$.asObserver(),
                           exhibitionButtonTapped: exhibitionButtonTapped$.asObserver(),
                           museumButtonTapped: museumButtonTapped$.asObserver(),
                           festivalButtonTapped: festivalButtonTapped$.asObserver(),
                           concertsButtonTapped: concertsButtonTapped$.asObserver(),
                           partyButtonTapped: partyButtonTapped$.asObserver(),
                           picnicButtonTapped: picnicButtonTapped$.asObserver(),
                           boardgameButtonTapped: boardgameButtonTapped$.asObserver(),
                           sportsButtonTapped: sportsButtonTapped$.asObserver(),
                           volunteerButtonTapped: volunteerButtonTapped$.asObserver(),
                           projcetsButtonTapped: projcetsButtonTapped$.asObserver(),
                           careerButtonTapped: careerButtonTapped$.asObserver())
        
        self.output = Output(categories: categories,
                             travel: travel,
                             eat_out: eat_out,
                             cafe: cafe,
                             cooking: cooking,
                             vegan: vegan,
                             bar: bar,
                             language: language,
                             discussion: discussion,
                             dance: dance,
                             kpop: kpop,
                             study: study,
                             read: read,
                             instruments: instruments,
                             draw: draw,
                             movie: movie,
                             exhibition: exhibition,
                             museum: museum,
                             festival: festival,
                             concerts: concerts,
                             party: party,
                             picnic: picnic,
                             boardgame: boardgame,
                             sports: sports,
                             volunteer: volunteer,
                             projcets: projcets,
                             career: career)
        
        // MARK: Bindind
        self.categories$ = categories$
        
        travelButtonTapped$
            .map { Hangout.Category.Travel }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        eat_outButtonTapped$
            .map { Hangout.Category.Eat_out }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        cafeButtonTapped$
            .map { Hangout.Category.Cafe }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        cookingButtonTapped$
            .map { Hangout.Category.Cooking }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        veganButtonTapped$
            .map { Hangout.Category.Vegan }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        barButtonTapped$
            .map { Hangout.Category.Bar }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        languageButtonTapped$
            .map { Hangout.Category.Language }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        discussionButtonTapped$
            .map { Hangout.Category.Discussion }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        danceButtonTapped$
            .map { Hangout.Category.Dance }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        kpopButtonTapped$
            .map { Hangout.Category.KPOP }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        studyButtonTapped$
            .map { Hangout.Category.Study }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        readButtonTapped$
            .map { Hangout.Category.Read }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        instrumentsButtonTapped$
            .map { Hangout.Category.Instruments }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        drawButtonTapped$
            .map { Hangout.Category.Draw }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        movieButtonTapped$
            .map { Hangout.Category.Movie }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        exhibitionButtonTapped$
            .map { Hangout.Category.Exhibition }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        museumButtonTapped$
            .map { Hangout.Category.Museum }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        festivalButtonTapped$
            .map { Hangout.Category.Festival }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        concertsButtonTapped$
            .map { Hangout.Category.Concerts }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        partyButtonTapped$
            .map { Hangout.Category.Party }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        picnicButtonTapped$
            .map { Hangout.Category.Picnic }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        boardgameButtonTapped$
            .map { Hangout.Category.Boardgame }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        sportsButtonTapped$
            .map { Hangout.Category.Sports }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        volunteerButtonTapped$
            .map { Hangout.Category.Volunteer }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        careerButtonTapped$
            .map { Hangout.Category.Career }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
        
        projcetsButtonTapped$
            .map { Hangout.Category.Projcets }
            .withLatestFrom(categories$, resultSelector: flipInterestOfDict)
            .bind(to: categories$)
            .disposed(by: disposeBag)
    }
}

private func flipInterestOfDict(interest: Hangout.Category, in interests: [Hangout.Category: Bool]) -> [Hangout.Category: Bool] {
    var dict = interests
    dict[interest] = !(interests[interest] ?? false)
    return dict
}
