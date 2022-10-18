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
        var numOfLikedHangouts: AnyObserver<Int?> // <-> Parent
        var numOfReferenceHangouts: AnyObserver<Int?> // <-> Parent
        var joinedButtonTapped: AnyObserver<Void> // <-> View
        var madeButtonTapped: AnyObserver<Void> // <-> View
        var likedButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var selectedIndex: Signal<Int> // <-> View
        var numOfJoinedHangouts: Driver<String> // <-> View
        var numOfLikedHangouts: Driver<String> // <-> View
        var numOfReferenceHangouts: Driver<String> // <-> View
        var selectedButtonIndex: Signal<Int> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let selectedIndex$ = PublishSubject<Int>()
    private let numOfJoinedHangouts$ = BehaviorSubject<Int?>(value: nil)
    private let numOfLikedHangouts$ = BehaviorSubject<Int?>(value: nil)
    private let numOfReferenceHangouts$ = BehaviorSubject<Int?>(value: nil)
    private let joinedButtonTapped$ = PublishSubject<Void>()
    private let likedButtonTapped$ = PublishSubject<Void>()
    private let referenceButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let selectedIndex = selectedIndex$
            .asSignal(onErrorJustReturn: 0)
        let numOfJoinedHangouts = numOfJoinedHangouts$
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let numOfLikedHangouts = numOfLikedHangouts$
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let numOfReferenceHangouts = numOfReferenceHangouts$
            .map { $0 ?? 0 }
            .map(String.init)
            .asDriver(onErrorJustReturn: "0")
        let selectedButtonIndex = Observable
            .merge(
                joinedButtonTapped$.map { 0 },
                likedButtonTapped$.map { 1 },
                referenceButtonTapped$.map { 2 }
            )
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            selectedIndex: selectedIndex$.asObserver(),
            numOfJoinedHangouts: numOfJoinedHangouts$.asObserver(),
            numOfLikedHangouts: numOfLikedHangouts$.asObserver(),
            numOfReferenceHangouts: numOfReferenceHangouts$.asObserver(),
            joinedButtonTapped: joinedButtonTapped$.asObserver(),
            madeButtonTapped: likedButtonTapped$.asObserver(),
            likedButtonTapped: referenceButtonTapped$.asObserver()
        )
        
        self.output = Output(
            selectedIndex: selectedIndex,
            numOfJoinedHangouts: numOfJoinedHangouts,
            numOfLikedHangouts: numOfLikedHangouts,
            numOfReferenceHangouts: numOfReferenceHangouts,
            selectedButtonIndex: selectedButtonIndex
        )
        
        // MARK: Bindind
        Observable
            .merge(
                joinedButtonTapped$.map { 0 },
                likedButtonTapped$.map { 1 },
                referenceButtonTapped$.map { 2 }
            )
            .bind(to: selectedIndex$)
            .disposed(by: disposeBag)
    }
}
