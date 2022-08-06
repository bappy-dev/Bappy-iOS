//
//  ProfileButtonSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/01.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileButtonSectionViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var selectedIndex: AnyObserver<Int> // <-> Parent
        var user: AnyObserver<BappyUser?> // <-> Parent
        var joinedButtonTapped: AnyObserver<Void> // <-> View
        var madeButtonTapped: AnyObserver<Void> // <-> View
        var likedButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var numOfJoined: Signal<String> // <-> View
        var numOfMade: Signal<String> // <-> View
        var numOfLiked: Signal<String> // <-> View
        var selectedIndex: Signal<Int> // <-> View
        var selectedButtonIndex: Signal<Int> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let selectedIndex$ = PublishSubject<Int>()
    private let user$ = BehaviorSubject<BappyUser?>(value: nil)
    private let joinedButtonTapped$ = PublishSubject<Void>()
    private let madeButtonTapped$ = PublishSubject<Void>()
    private let likedButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        
        let numOfJoined = user$
            .compactMap { $0 }
            .map(\.numOfJoinedHangouts)
            .map { $0 ?? 0}
            .map(String.init)
            .asSignal(onErrorJustReturn: "0")
        let numOfMade = user$
            .compactMap { $0 }
            .map(\.numOfMadeHangouts)
            .map { $0 ?? 0}
            .map(String.init)
            .asSignal(onErrorJustReturn: "0")
        let numOfLiked = user$
            .compactMap { $0 }
            .map(\.numOfLikedHangouts)
            .map { $0 ?? 0}
            .map(String.init)
            .asSignal(onErrorJustReturn: "0")
        let selectedIndex = selectedIndex$
            .asSignal(onErrorJustReturn: 0)
        let selectedButtonIndex = Observable
            .merge(
                joinedButtonTapped$.map { 0 },
                madeButtonTapped$.map { 1 },
                likedButtonTapped$.map { 2 }
            )
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            selectedIndex: selectedIndex$.asObserver(),
            user: user$.asObserver(),
            joinedButtonTapped: joinedButtonTapped$.asObserver(),
            madeButtonTapped: madeButtonTapped$.asObserver(),
            likedButtonTapped: likedButtonTapped$.asObserver()
        )
        
        self.output = Output(
            numOfJoined: numOfJoined,
            numOfMade: numOfMade,
            numOfLiked: numOfLiked,
            selectedIndex: selectedIndex,
            selectedButtonIndex: selectedButtonIndex
        )
        
        // MARK: Bindind
        Observable
            .merge(
                joinedButtonTapped$.map { 0 },
                madeButtonTapped$.map { 1 },
                likedButtonTapped$.map { 2 }
            )
            .bind(to: selectedIndex$)
            .disposed(by: disposeBag)
    }
}
