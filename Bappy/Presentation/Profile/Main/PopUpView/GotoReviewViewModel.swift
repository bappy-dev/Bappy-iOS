//
//  GotoReviewViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

final class GotoReviewViewModel: ViewModelType {
    struct Dependency {
        let hangoutID: String
        let bappyAuthRepository: BappyAuthRepository
        let hangoutRepository: HangoutRepository
        
        init(hangoutID: String,
             bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared,
             hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.hangoutID = hangoutID
            self.bappyAuthRepository = bappyAuthRepository
            self.hangoutRepository = hangoutRepository
        }
    }
    
    struct Input {
        var okayButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var moveToWriteReviewView: Driver<(HangoutDetailViewModel, WriteReviewViewModel)?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let okayButtonTapped$ = PublishSubject<Void>()
    
    private let hangoutDetail$ = BehaviorSubject<Hangout?>(value: nil)
    private let targetList$ = BehaviorSubject<Hangout?>(value: nil)
    private let moveToWriteReviewView$ = PublishSubject<(HangoutDetailViewModel, WriteReviewViewModel)?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        let moveToWriteReviewView = moveToWriteReviewView$
        
        // MARK: Input & Output
        self.input = Input(
            okayButtonTapped: okayButtonTapped$.asObserver()
        )
        
        self.output = Output(
            moveToWriteReviewView: moveToWriteReviewView.asDriver(onErrorJustReturn: nil)
        )

        let hangoutDetail = okayButtonTapped$
            .map { _ in dependency.hangoutID }
            .flatMap(dependency.hangoutRepository.fetchHangout)
            .share()

        hangoutDetail
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        hangoutDetail
            .compactMap(getValue)
            .bind(to: hangoutDetail$)
            .disposed(by: disposeBag)

        let targetList = okayButtonTapped$
            .map { _ in dependency.hangoutID }
            .flatMap(dependency.hangoutRepository.fetchHangout)
            .share()

        targetList
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        targetList
            .compactMap(getValue)
            .bind(to: targetList$)
            .disposed(by: disposeBag)
        
        // MARK: Binding
        Observable
            .combineLatest(hangoutDetail$.compactMap { $0 },
                           targetList$.compactMap { $0 })
            .withLatestFrom(currentUser$.compactMap { $0 }) {
                ($0.0, $0.1, $1)
            }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .map { hangout, targetList, user  -> (HangoutDetailViewModel, WriteReviewViewModel) in
                let hangoutDetailViewModel = HangoutDetailViewModel(dependency: HangoutDetailViewModel.Dependency(currentUser: user, hangout: hangout))
                let writeReviewViewModel = WriteReviewViewModel(dependency: WriteReviewViewModel.Dependency(targetList: targetList))
                return (hangoutDetailViewModel, writeReviewViewModel)
            }
            .drive(moveToWriteReviewView$)
            .disposed(by: disposeBag)
    }
}
