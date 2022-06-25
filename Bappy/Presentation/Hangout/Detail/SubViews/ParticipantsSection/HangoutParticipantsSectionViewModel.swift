//
//  HangoutParticipantsSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutParticipantsSectionViewModel: ViewModelType {
    
    struct Dependency {
        var limitNumber: Int
        var participantIDs: [Hangout.Info]
    }
    
    struct Input {}
    
    struct Output {
        var limitNumberText: Signal<String>
        var participantIDs: Driver<[Hangout.Info]>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let limitNumber$: BehaviorSubject<Int>
    private let participantIDs$: BehaviorSubject<[Hangout.Info]>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let limitNumber$ = BehaviorSubject<Int>(value: dependency.limitNumber)
        let participantIDs$ = BehaviorSubject<[Hangout.Info]>(value: dependency.participantIDs)
        
        let limitNumberText = limitNumber$
            .map { "Max \($0)" }
            .asSignal(onErrorJustReturn: "Max \(dependency.limitNumber)")
        let participantIDs = participantIDs$
            .asDriver(onErrorJustReturn: dependency.participantIDs)
        
        // Input & Output
        self.input = Input()
        
        self.output = Output(
            limitNumberText: limitNumberText,
            participantIDs: participantIDs
        )
        
        // Bindind
        self.limitNumber$ = limitNumber$
        self.participantIDs$ = participantIDs$
    }
}
