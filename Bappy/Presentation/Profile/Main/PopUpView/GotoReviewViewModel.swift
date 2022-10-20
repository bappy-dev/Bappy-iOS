//
//  GotoReviewViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

struct WriteReviewViewModel {}

final class GotoReviewViewModel: ViewModelType {
    struct Dependency {
        let hangoutID: String
        let bappyAuthRepository: BappyAuthRepository
        
        init(hangoutID: String,
             bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared) {
            self.hangoutID = hangoutID
            self.bappyAuthRepository = bappyAuthRepository
        }
    }
    
    struct Input {
        var okayButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var moveToWriteReviewView: Signal<WriteReviewViewModel?>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let okayButtonTapped$ = PublishSubject<Void>()
    
    private let moveToWriteReviewView$ = PublishSubject<WriteReviewViewModel?>()
    
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
        
        // MARK: Binding
        okayButtonTapped$
            .map { _  -> WriteReviewViewModel in
                return WriteReviewViewModel()
            }
            .bind(to: moveToWriteReviewView$)
            .disposed(by: disposeBag)
    }
}
