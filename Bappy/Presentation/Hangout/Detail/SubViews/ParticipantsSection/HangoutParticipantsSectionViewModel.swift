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
        var hangout: Hangout
        var limitNumber: Int { hangout.limitNumber }
        var joinedIDs: [Hangout.Info] { hangout.joinedIDs }
        var likedIDs: [Hangout.Info] { hangout.likedIDs }
    }
    
    struct Input {
        var joinedIDs: AnyObserver<[Hangout.Info]>
        var selectedUserID: AnyObserver<String?> // <-> View
        var likedIDs: AnyObserver<[Hangout.Info]>
    }
    
    struct Output {
        var limitNumberText: Signal<String> // <-> View
        var joinedIDs: Driver<[Hangout.Info]> // <-> View
        var likedIDs: Driver<[Hangout.Info]> // <-> View
        var selectedUserID: Signal<String?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let selectedUserID$ = PublishSubject<String?>()
    private let limitNumber$: BehaviorSubject<Int>
    private let likedIDs$: BehaviorSubject<[Hangout.Info]>
    private let joinedIDs$: BehaviorSubject<[Hangout.Info]>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let limitNumber$ = BehaviorSubject<Int>(value: dependency.limitNumber)
        let joinedIDs$ = BehaviorSubject<[Hangout.Info]>(value: dependency.joinedIDs)
        let likedIDs$ = BehaviorSubject<[Hangout.Info]>(value: dependency.likedIDs)
        
        let limitNumberText = limitNumber$
            .map { "Max \($0)" }
            .asSignal(onErrorJustReturn: "Max \(dependency.limitNumber)")
        let joinedIDs = joinedIDs$
            .asDriver(onErrorJustReturn: dependency.joinedIDs)
        let likedIDs = likedIDs$
            .asDriver(onErrorJustReturn: dependency.likedIDs)
        let selectedUserID = selectedUserID$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            joinedIDs: joinedIDs$.asObserver(),
            selectedUserID: selectedUserID$.asObserver(),
            likedIDs: likedIDs$.asObserver()
        )
        
        self.output = Output(
            limitNumberText: limitNumberText,
            joinedIDs: joinedIDs,
            likedIDs: likedIDs,
            selectedUserID: selectedUserID
        )
        
        // MARK: Bindind
        self.limitNumber$ = limitNumber$
        self.joinedIDs$ = joinedIDs$
        self.likedIDs$ = likedIDs$
    }
}
