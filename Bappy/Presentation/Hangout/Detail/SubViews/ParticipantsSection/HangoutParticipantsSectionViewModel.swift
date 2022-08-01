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
    
    struct Input {
        var itemSelected: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var limitNumberText: Signal<String> // <-> View
        var participantIDs: Driver<[Hangout.Info]> // <-> View
        var selectedUserID: Signal<String?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    private let limitNumber$: BehaviorSubject<Int>
    private let participantIDs$: BehaviorSubject<[Hangout.Info]>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let limitNumber$ = BehaviorSubject<Int>(value: dependency.limitNumber)
        let participantIDs$ = BehaviorSubject<[Hangout.Info]>(value: dependency.participantIDs)
        
        let limitNumberText = limitNumber$
            .map { "Max \($0)" }
            .asSignal(onErrorJustReturn: "Max \(dependency.limitNumber)")
        let participantIDs = participantIDs$
            .asDriver(onErrorJustReturn: dependency.participantIDs)
        let selectedUserID = itemSelected$
            .withLatestFrom(participantIDs$) { $1[$0.row].id }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            limitNumberText: limitNumberText,
            participantIDs: participantIDs,
            selectedUserID: selectedUserID
        )
        
        // MARK: Bindind
        self.limitNumber$ = limitNumber$
        self.participantIDs$ = participantIDs$
    }
}
