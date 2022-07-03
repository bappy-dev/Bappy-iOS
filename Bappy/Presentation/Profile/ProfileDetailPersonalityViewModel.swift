//
//  ProfileDetailPersonalityViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/03.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailPersonalityViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
    }
    
    struct Input {}
    
    struct Output {
        var spontaneous: Driver<Bool>
        var planning: Driver<Bool>
        var talkative: Driver<Bool>
        var empathic: Driver<Bool>
        var shy: Driver<Bool>
        var calm: Driver<Bool>
        var polite: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let spontaneous = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Spontaneous) }
            .asDriver(onErrorJustReturn: false)
        let planning = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Planning) }
            .asDriver(onErrorJustReturn: false)
        let talkative = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Talkative) }
            .asDriver(onErrorJustReturn: false)
        let empathic = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Empathatic) }
            .asDriver(onErrorJustReturn: false)
        let shy = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Shy) }
            .asDriver(onErrorJustReturn: false)
        let calm = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Calm) }
            .asDriver(onErrorJustReturn: false)
        let polite = user$
            .map { $0.personalities ?? [] }
            .map { $0.contains(.Polite) }
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input()
        
        self.output = Output(
            spontaneous: spontaneous,
            planning: planning,
            talkative: talkative,
            empathic: empathic,
            shy: shy,
            calm: calm,
            polite: polite
        )
        
        // Bindind
        self.user$ = user$
    }
}
