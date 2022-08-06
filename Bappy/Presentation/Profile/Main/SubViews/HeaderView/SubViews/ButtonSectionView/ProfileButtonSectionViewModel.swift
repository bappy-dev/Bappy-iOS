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
        var numOfJoinedHangouts: AnyObserver<Int?> // <-> Parent
        var numOfMadeHangouts: AnyObserver<Int?> // <-> Parent
        var numOfLikedHangouts: AnyObserver<Int?> // <-> Parent
        var joinedButtonTapped: AnyObserver<Void> // <-> View
        var madeButtonTapped: AnyObserver<Void> // <-> View
        var likedButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var selectedIndex: Signal<Int> // <-> View
        var numOfJoinedHangouts: Driver<String> // <-> View
        var numOfMadeHangouts: Driver<String> // <-> View
        var numOfLikedHangouts: Driver<String> // <-> View
        var selectedButtonIndex: Signal<Int> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let selectedIndex$ = PublishSubject<Int>()
    private let numOfJoinedHangouts$ = BehaviorSubject<Int?>(value: nil)
    private let numOfMadeHangouts$ = BehaviorSubject<Int?>(value: nil)
    private let numOfLikedHangouts$ = BehaviorSubject<Int?>(value: nil)
    private let joinedButtonTapped$ = PublishSubject<Void>()
    private let madeButtonTapped$ = PublishSubject<Void>()
    private let likedButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let selectedIndex = selectedIndex$
            .asSignal(onErrorJustReturn: 0)
        let numOfJoinedHangouts = numOfJoinedHangouts$
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let numOfMadeHangouts = numOfMadeHangouts$
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let numOfLikedHangouts = numOfLikedHangouts$
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
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
            numOfJoinedHangouts: numOfJoinedHangouts$.asObserver(),
            numOfMadeHangouts: numOfMadeHangouts$.asObserver(),
            numOfLikedHangouts: numOfLikedHangouts$.asObserver(),
            joinedButtonTapped: joinedButtonTapped$.asObserver(),
            madeButtonTapped: madeButtonTapped$.asObserver(),
            likedButtonTapped: likedButtonTapped$.asObserver()
        )
        
        self.output = Output(
            selectedIndex: selectedIndex,
            numOfJoinedHangouts: numOfJoinedHangouts,
            numOfMadeHangouts: numOfMadeHangouts,
            numOfLikedHangouts: numOfLikedHangouts,
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
