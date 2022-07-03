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
        let bappyAuthRepository: BappyAuthRepository
    }
    
    struct Input {
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
    
    private let joinedButtonTapped$ = PublishSubject<Void>()
    private let madeButtonTapped$ = PublishSubject<Void>()
    private let likedButtonTapped$ = PublishSubject<Void>()
    
    private let numOfJoined$: BehaviorSubject<String>
    private let numOfMade$: BehaviorSubject<String>
    private let numOfLiked$: BehaviorSubject<String>
    private let selectedIndex$ = BehaviorSubject<Int>(value: 0)
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let numOfJoined$ = BehaviorSubject<String>(value: "\(dependency.user.numOfJoinedHangouts ?? 0)")
        let numOfMade$ = BehaviorSubject<String>(value: "\(dependency.user.numOfMadeHangouts ?? 0)")
        let numOfLiked$ = BehaviorSubject<String>(value: "\(dependency.user.numOfLikedHangouts ?? 0)")
        
        let numOfJoined = numOfJoined$
            .asDriver(onErrorJustReturn: "0")
        let numOfMade = numOfMade$
            .asDriver(onErrorJustReturn: "0")
        let numOfLiked = numOfLiked$
            .asDriver(onErrorJustReturn: "0")
        let selectedIndex = selectedIndex$
            .asDriver(onErrorJustReturn: 0)
        
        // Input & Output
        self.input = Input(
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
        
        // Bindind
        self.numOfJoined$ = numOfJoined$
        self.numOfMade$ = numOfMade$
        self.numOfLiked$ = numOfLiked$
        
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
