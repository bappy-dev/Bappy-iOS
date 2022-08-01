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
    
    private let user$: BehaviorSubject<BappyUser>
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let travel = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Travel) }
            .asDriver(onErrorJustReturn: false)
        let study = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Study) }
            .asDriver(onErrorJustReturn: false)
        let sports = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Sports) }
            .asDriver(onErrorJustReturn: false)
        let food = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Food) }
            .asDriver(onErrorJustReturn: false)
        let drinks = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Drinks) }
            .asDriver(onErrorJustReturn: false)
        let cook = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Cook) }
            .asDriver(onErrorJustReturn: false)
        let culture = user$
            .map { $0.interests ?? [] }
            .map { $0.contains(.Culture) }
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
        
        // MARK: Input & Output
        self.input = Input()
        
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
        
        // MARK: Bindind
        self.user$ = user$
    }
}
