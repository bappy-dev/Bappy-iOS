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

struct MakeReferenceModel {
    var targetID: String
    var tags: [String]
    var message: String
}

final class WriteReviewViewModel: ViewModelType {
    struct Dependency {
        let targetList: [TargetInfo]
        let hangoutRepository: HangoutRepository

        init(targetList: Hangout, hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.targetList = [TargetInfo(id: "aaa"), TargetInfo(id: "bbb"), TargetInfo(id: "ccc"), TargetInfo(id: "ddd"), TargetInfo(id: "eee")]
            self.hangoutRepository = hangoutRepository
        }
    }
    
    struct SubViewModels {
        let continueButtonViewModel: ContinueButtonViewModel
        let reviewSelectTagViewModel: ReviewSelectTagViewModel
    }
    struct Input {
        var viewDidAppear: AnyObserver<Bool> // <-> View
        var continueButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var backButtonTapped: AnyObserver<Void> // <-> View
        var tags: AnyObserver<[String]> // <-> View
        var message: AnyObserver<String> // <-> View
    }

    struct Output {
        var progression: Driver<CGFloat> // <-> View
        var initProgression: Signal<CGFloat> // <-> View
        var shouldKeyboardHide: Signal<Void> // <-> View
        var nowValues: Driver<MakeReferenceModel> // <-> View
        var isContinueButtonEnabled: Signal<Bool> // <-> Child(Continue)
        var reviews: Signal<[MakeReferenceModel]>
    }

    var dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    var input: Input
    var output: Output
    
    private let viewDidAppear$ = PublishSubject<Bool>()
    private let index$ = BehaviorSubject<Int>(value: 0)
    private let continueButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let tags$ = BehaviorSubject<[String]>(value: [])
    private let isTagsValid$ = BehaviorSubject<Bool>(value: false)
    private let message$ = BehaviorSubject<String>(value: "")
    private let reviews$ = BehaviorSubject<[MakeReferenceModel]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            continueButtonViewModel: ContinueButtonViewModel(),
            reviewSelectTagViewModel: ReviewSelectTagViewModel()
        )
        
        // MARK: Streams
        let progression = index$
            .map { getProgression(currentPage: $0, numOfPage: dependency.targetList.count) }
            .asDriver(onErrorJustReturn: .zero)
        let initProgression = viewDidAppear$
            .withLatestFrom(progression)
            .asSignal(onErrorJustReturn: 0)
        
        let shouldKeyboardHide = Observable
            .merge(continueButtonTapped$, backButtonTapped$)
            .asSignal(onErrorJustReturn: Void())
        
        let isContinueButtonEnabled = Observable
            .combineLatest(
                index$.filter { $0 >= 0 && $0 < dependency.targetList.count },
                isTagsValid$,
                resultSelector: { index, isTagsValid in
                    isTagsValid
                }
            )
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        
        let nowValues = index$
            .withLatestFrom(reviews$) { ($0, $1) }
            .map { (index, reviews) in
                if index > 0 &&  index < reviews.count {
                    return reviews[index]
                } else {
                    return MakeReferenceModel(targetID: "", tags: [], message: "")
                }
            }
            .asDriver(onErrorJustReturn: MakeReferenceModel(targetID: "", tags: [], message: ""))
        
        // MARK: Input & Output
        self.input = Input(
            viewDidAppear: viewDidAppear$.asObserver(),
            continueButtonTapped: continueButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver(),
            tags: tags$.asObserver(),
            message: message$.asObserver()
        )
        
        self.output = Output(
            progression: progression,
            initProgression: initProgression,
            shouldKeyboardHide: shouldKeyboardHide,
            nowValues: nowValues,
            isContinueButtonEnabled: isContinueButtonEnabled,
            reviews: reviews$.asSignal(onErrorJustReturn: [])
        )

        // MARK: Binding
        continueButtonTapped$
            .withLatestFrom(index$) { $1 + 1 }
            .map {
                print("지금", $0)
                return $0
            }
            .bind(to: index$)
            .disposed(by: disposeBag)
        
        // 리뷰 작성 또는 업데이트
        index$
            .filter {
                $0 != 0 && $0 < dependency.targetList.count
            }
            .withLatestFrom(Observable.combineLatest(reviews$, tags$, message$)) {
                ($0, $1.0, $1.1, $1.2)
            }
            .map { (index, reviews, tags, message) in
                print(index, reviews)
                let review = MakeReferenceModel(targetID: dependency.targetList[index-1].id,
                                                tags: tags,
                                                message: message)
                if index > reviews.count {
                    return reviews + [review]
                } else {
                    var reviews = reviews
                    reviews[index-1] = review
                    return reviews
                }
            }
            .bind(to: reviews$)
            .disposed(by: disposeBag)
        
        // 마지막, 제츨
        index$
            .filter {
                $0 == dependency.targetList.count
            }
            .withLatestFrom(Observable.combineLatest(reviews$, tags$, message$)) {
                ($0, $1.0, $1.1, $1.2)
            }
            .map { (index, reviews, tags, message) in
                let review = MakeReferenceModel(targetID: dependency.targetList[index-1].id,
                                                tags: tags,
                                                message: message)
                let reviews = reviews + [review]
                print(index, reviews)
                // dependency.hangoutRepository.makeReview()
            }
            .subscribe {
                print("얍", $0)
            }
            .disposed(by: disposeBag)
        
        // Child(Tag)
        subViewModels.reviewSelectTagViewModel.output.tags
            .map({ tags in
                tags.map { $0.description }
            })
            .emit(to: tags$)
            .disposed(by: disposeBag)
        
        subViewModels.reviewSelectTagViewModel.output.isValid
            .drive(isTagsValid$)
            .disposed(by: disposeBag)
        
        // ContinueButton
        output.isContinueButtonEnabled
            .emit(to: subViewModels.continueButtonViewModel.input.isButtonEnabled)
            .disposed(by: disposeBag)
        
        subViewModels.continueButtonViewModel.output.continueButtonTapped
            .emit(to: continueButtonTapped$)
            .disposed(by: disposeBag)
    }
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}
