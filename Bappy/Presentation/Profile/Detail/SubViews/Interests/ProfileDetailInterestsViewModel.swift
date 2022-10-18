//
//  ProfileDetailInterestsViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/03.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailInterestsViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
    }
    
    struct Input {}
    
    struct Output {
        var travel: Driver<Bool>
        var cafe: Driver<Bool>
        var hiking: Driver<Bool>
        var food: Driver<Bool>
        var bar: Driver<Bool>
        var cook: Driver<Bool>
        var shopping: Driver<Bool>
        var volunteer: Driver<Bool>
        var language: Driver<Bool>
        var crafting: Driver<Bool>
        var music: Driver<Bool>
        var ballgame: Driver<Bool>
        var vegan: Driver<Bool>
        var running: Driver<Bool>
        var concerts: Driver<Bool>
        var museum: Driver<Bool>
        var boardgame: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let travel = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Travel) }
            .asDriver(onErrorJustReturn: false)
        let cafe = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Cafe) }
            .asDriver(onErrorJustReturn: false)
        let hiking = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Hiking) }
            .asDriver(onErrorJustReturn: false)
        let food = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Food) }
            .asDriver(onErrorJustReturn: false)
        let bar = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Bar) }
            .asDriver(onErrorJustReturn: false)
        let cook = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Cook) }
            .asDriver(onErrorJustReturn: false)
        let shopping = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Shopping) }
            .asDriver(onErrorJustReturn: false)
        let volunteer = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Volunteer) }
            .asDriver(onErrorJustReturn: false)
        let language = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Language) }
            .asDriver(onErrorJustReturn: false)
        let crafting = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Crafting) }
            .asDriver(onErrorJustReturn: false)
        let music = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Music) }
            .asDriver(onErrorJustReturn: false)
        let ballgame = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.BallGame) }
            .asDriver(onErrorJustReturn: false)
        let vegan = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Vegan) }
            .asDriver(onErrorJustReturn: false)
        let running = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Running) }
            .asDriver(onErrorJustReturn: false)
        let concerts = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Concerts) }
            .asDriver(onErrorJustReturn: false)
        let museum = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Museum) }
            .asDriver(onErrorJustReturn: false)
        let boardgame = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Boardgame) }
            .asDriver(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(travel: travel,
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
                             boardgame: boardgame)
        
        // MARK: Bindind
        self.user$ = user$
    }
}
