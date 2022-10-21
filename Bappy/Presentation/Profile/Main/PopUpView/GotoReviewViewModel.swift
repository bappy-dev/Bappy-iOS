//
//  GotoReviewViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

final class WriteReviewViewModel {}

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
        var moveToWriteReviewView: Signal<WriteReviewViewModel?>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let okayButtonTapped$ = PublishSubject<Void>()
    
    private let hangoutDetail$ = BehaviorSubject<Hangout?>(value: nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let moveToWriteReviewView = moveToWriteReviewView$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            okayButtonTapped: okayButtonTapped$.asObserver()
        )
        
        self.output = Output(
            moveToWriteReviewView: moveToWriteReviewView
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

        // MARK: Binding
    }
}
