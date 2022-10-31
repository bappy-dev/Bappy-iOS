//
//  WriteReviewViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa

struct MakeReferenceModel {
    var targetID: String
    var tags: [String]
    var message: String
}

final class WriteReviewViewModel: ViewModelType {
    struct Dependency {
        let hangoutID: String
        let targetList: [Hangout.Info]
        let hangoutRepository: HangoutRepository
        let bappyAuthRepository: BappyAuthRepository

        init(hangoutID: String, targetList: [Hangout.Info], hangoutRepository: HangoutRepository = DefaultHangoutRepository(), bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared) {
            self.hangoutID = hangoutID
            self.targetList = targetList
            self.hangoutRepository = hangoutRepository
            self.bappyAuthRepository = bappyAuthRepository
        }
    }
    
    struct SubViewModels {
        let moveWithKeyboardViewModel: MoveWithKeyboardViewModel
        let reviewSelectTagViewModel: ReviewSelectTagViewModel
    }
    struct Input {
        var viewDidAppear: AnyObserver<Bool> // <-> View
        var continueButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var backButtonTapped: AnyObserver<Void> // <-> Child(Top)
        var tags: AnyObserver<[String]> // <-> View
        var message: AnyObserver<String> // <-> Child(Top)
    }

    struct Output {
        var progression: Driver<CGFloat> // <-> View
        var initProgression: Signal<CGFloat> // <-> View
        var shouldKeyboardHide: Signal<Void> // <-> View
        var nowValues: Driver<MakeReferenceModel> // <-> View
        var isContinueButtonEnabled: Signal<Bool> // <-> Child(Continue)
        var index: Driver<Int> // <-> View
        var reviews: Signal<[MakeReferenceModel]>
        var showCompleteView: Signal<MakeReviewCompletedViewModel?> // <-> View
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
    private let showCompleteView$ = PublishSubject<MakeReviewCompletedViewModel?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            moveWithKeyboardViewModel: MoveWithKeyboardViewModel(),
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
        
        let nowValue = index$
            .withLatestFrom(reviews$) { ($0, $1) }
            .map { (index, reviews) in
                if index >= 0 && index < reviews.count {
                    print("nowValues", index, reviews[index])
                    return reviews[index]
                } else {
                    print("nowValues 새 거", index)
                    return MakeReferenceModel(targetID: "", tags: [], message: "")
                }
            }
            .share()
        
        nowValue
            .map { $0.tags }
            .bind(to: tags$)
            .disposed(by: disposeBag)

        nowValue
            .map { $0.message }
            .bind(to: message$)
            .disposed(by: disposeBag)
        
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
            nowValues: nowValue.asDriver(onErrorJustReturn: MakeReferenceModel(targetID: "",
                                                                               tags: [],
                                                                               message: "")),
            isContinueButtonEnabled: isContinueButtonEnabled,
            index: index$.asDriver(onErrorJustReturn: 0),
            reviews: reviews$.asSignal(onErrorJustReturn: []),
            showCompleteView: showCompleteView$.asSignal(onErrorJustReturn: nil)
        )

        // MARK: Binding
        backButtonTapped$
            .withLatestFrom(index$) { $1 - 1 }
            .filter { $0 >= 0 }
            .map {
                print("지금", $0)
                return $0
            }
            .bind(to: index$)
            .disposed(by: disposeBag)
        
        // 리뷰 작성 또는 업데이트
        let endNowIndex = continueButtonTapped$
            .withLatestFrom(Observable.combineLatest(index$, reviews$, tags$, message$)) {
                ($1.0, $1.1, $1.2, $1.3)
            }
            .share()
        
        endNowIndex
            .filter {
                $0.0 + 1 < dependency.targetList.count
            }
            .map { (index, reviews, tags, message) in
                index + 1
            }
            .bind(to: index$)
            .disposed(by: disposeBag)
        
        endNowIndex
            .filter {
                $0.0 + 1 < dependency.targetList.count
            }
            .map { (index, reviews, tags, message) in
                let review = MakeReferenceModel(targetID: dependency.targetList[index].id,
                                                tags: tags,
                                                message: message)
                print(index, reviews, review)
                if index >= reviews.count {
                    return reviews + [review]
                } else {
                    var reviews = reviews
                    print("업데이트", review)
                    reviews[index] = review
                    return reviews
                }
            }
            .bind(to: reviews$)
            .disposed(by: disposeBag)
        
        // 마지막, 제츨
        let result = endNowIndex
            .filter {
                $0.0 + 1 == dependency.targetList.count
            }
            .map { (index, reviews, tags, message) in
                let review = MakeReferenceModel(targetID: dependency.targetList[index].id,
                                                tags: tags,
                                                message: message)
                return dependency.hangoutRepository.makeReviews(referenceModels: reviews + [review], hangoutID: dependency.hangoutID)
            }
            .flatMap { $0 }
            .share()

        result
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)

        result
            .compactMap(getValue)
            .withLatestFrom(dependency.bappyAuthRepository.currentUser) { $1 }
            .compactMap { $0 }
            .map { user in MakeReviewCompletedViewModel(dependency: .init(user: user)) }
            .bind(to: showCompleteView$)
            .disposed(by: disposeBag)
        
        result
            .compactMap(getValue)
            .subscribe(onNext: { [unowned self] result in
                if !result { return }
                var reviews = UserDefaults.standard.value(forKey: "Reviews") as? [String] ?? []
                reviews.append(self.dependency.hangoutID)
                UserDefaults.standard.set(reviews, forKey: "Reviews")
            })
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
        
        // Child
        output.isContinueButtonEnabled
            .emit(to: subViewModels.moveWithKeyboardViewModel.input.isButtonEnabled)
            .disposed(by: disposeBag)
        
        subViewModels.moveWithKeyboardViewModel.output.continueButtonTapped
            .emit(to: continueButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.moveWithKeyboardViewModel.output.text
            .emit(to: message$)
            .disposed(by: disposeBag)
        
        subViewModels.moveWithKeyboardViewModel.output.backButtonTapped
            .emit(to: backButtonTapped$)
            .disposed(by: disposeBag)
    }
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}
