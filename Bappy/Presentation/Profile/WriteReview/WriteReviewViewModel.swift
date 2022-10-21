//
//  WriteReviewViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa

struct TargetInfo {
    var id: String = "aaa"
    var profileImage: URL? = nil
}

final class WriteReviewViewModel: ViewModelType {
    struct Dependency {
        let targetList: [TargetInfo]
        let hangoutRepository: HangoutRepository

        init(targetList: Hangout, hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.targetList = [TargetInfo(id: "aaa"), TargetInfo(id: "bbb")]
            self.hangoutRepository = hangoutRepository
        }
    }
    
    struct SubViewModels {
        let continueButtonViewModel: ContinueButtonViewModel
    }
    struct Input {
        var viewDidAppear: AnyObserver<Bool> // <-> View
        var continueButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var backButtonTapped: AnyObserver<Void> // <-> View
    }

    struct Output {
        var progression: Driver<CGFloat> // <-> View
        var initProgression: Signal<CGFloat> // <-> View
        var shouldKeyboardHide: Signal<Void> // <-> View
    }

    var dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    var input: Input
    var output: Output
    
    private let viewDidAppear$ = PublishSubject<Bool>()
    private let index$ = PublishSubject<Int>()
    private let continueButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            continueButtonViewModel: ContinueButtonViewModel()
        )
        
        // MARK: Streams
        let progression = index$
            .map { getProgression(currentPage: $0, numOfPage: 5) }
            //.map { getProgression(currentPage: $0, numOfPage: dependency.targetList.count) }
            .asDriver(onErrorJustReturn: .zero)
        let initProgression = viewDidAppear$
            .withLatestFrom(progression)
            .asSignal(onErrorJustReturn: 0)
        
        let shouldKeyboardHide = Observable
            .merge(continueButtonTapped$, backButtonTapped$)
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            viewDidAppear: viewDidAppear$.asObserver(),
            continueButtonTapped: continueButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver()
        )
        
        self.output = Output(
            progression: progression,
            initProgression: initProgression,
            shouldKeyboardHide: shouldKeyboardHide
        )

        // MARK: Binding
        
    }
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}
