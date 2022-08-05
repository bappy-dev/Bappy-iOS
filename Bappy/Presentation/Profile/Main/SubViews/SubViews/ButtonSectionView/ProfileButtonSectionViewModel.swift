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
    
    struct Dependency {
        let user: BappyUser
    }
    
    struct Input {
        var user: AnyObserver<BappyUser> // <-> Parent
        var joinedButtonTapped: AnyObserver<Void> // <-> View
        var madeButtonTapped: AnyObserver<Void> // <-> View
        var likedButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var numOfJoined: Driver<String> // <-> View
        var numOfMade: Driver<String> // <-> View
        var numOfLiked: Driver<String> // <-> View
        var selectedIndex: Driver<Int> // <-> View, Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
    private let joinedButtonTapped$ = PublishSubject<Void>()
    private let madeButtonTapped$ = PublishSubject<Void>()
    private let likedButtonTapped$ = PublishSubject<Void>()

    private let selectedIndex$ = BehaviorSubject<Int>(value: 0)
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let numOfJoined = user$
            .map(\.numOfJoinedHangouts)
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let numOfMade = user$
            .map(\.numOfMadeHangouts)
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let numOfLiked = user$
            .map(\.numOfLikedHangouts)
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let selectedIndex = selectedIndex$
            .asDriver(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            user: user$.asObserver(),
            joinedButtonTapped: joinedButtonTapped$.asObserver(),
            madeButtonTapped: madeButtonTapped$.asObserver(),
            likedButtonTapped: likedButtonTapped$.asObserver()
        )
        
        self.output = Output(
            numOfJoined: numOfJoined,
            numOfMade: numOfMade,
            numOfLiked: numOfLiked,
            selectedIndex: selectedIndex
        )
        
        // MARK: Bindind
        self.user$ = user$
        
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
