//
//  HangoutMakeViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeViewModel: ViewModelType {
    
    struct SubViewModels {
        let categoryViewModel: HangoutMakeCategoryViewModel
        let titleViewModel: HangoutMakeTitleViewModel
        let timeViewModel: HangoutMakeTimeViewModel
        let placeViewModel: HangoutMakePlaceViewModel
        let pictureViewModel: HangoutMakePictureViewModel
        let planViewModel: HangoutMakePlanViewModel
        let languageViewModel: HangoutMakeLanguageViewModel
        let openchatViewModel: HangoutMakeOpenchatViewModel
        let limitViewModel: HangoutMakeLimitViewModel
        let continueButtonViewModel: ContinueButtonViewModel
    }
    
    struct Dependency {
        var numOfPage: Int
        var categoryDependency: HangoutMakeCategoryViewModel.Dependency
        var titleDependency: HangoutMakeTitleViewModel.Dependency
        var timeDependency: HangoutMakeTimeViewModel.Dependency
        var placeDependency: HangoutMakePlaceViewModel.Dependency
        var pictureDependency: HangoutMakePictureViewModel.Dependency
        var planDependency: HangoutMakePlanViewModel.Dependency
        var languageDependency: HangoutMakeLanguageViewModel.Dependency
        var openchatDependency: HangoutMakeOpenchatViewModel.Dependency
        var limitDependency: HangoutMakeLimitViewModel.Dependency
        var searchPlaceDependency: SearchPlaceViewModel.Dependency
    }
    
    struct Input {
        var continueButtonTapped: AnyObserver<Void>
        var backButtonTapped: AnyObserver<Void>
        var viewDidAppear: AnyObserver<Bool>
        var keyboardWithButtonHeight: AnyObserver<CGFloat>
        var categories: AnyObserver<[HangoutCategory: Bool]>
        var title: AnyObserver<String>
        var date: AnyObserver<Date?>
        var place: AnyObserver<Map?>
        var picture: AnyObserver<UIImage?>
        var plan: AnyObserver<String>
        var language: AnyObserver<String>
        var openchat: AnyObserver<String>
        var limit: AnyObserver<Int?>
        var isCategoriesValid: AnyObserver<Bool>
        var isTitleValid: AnyObserver<Bool>
        var isTimeValid: AnyObserver<Bool>
        var isPlaceValid: AnyObserver<Bool>
        var isPictureValid: AnyObserver<Bool>
        var isPlanValid: AnyObserver<Bool>
        var isLanguageValid: AnyObserver<Bool>
        var isOpenchatValid: AnyObserver<Bool>
        var isLimitValid: AnyObserver<Bool>
        var showSearchView: AnyObserver<SearchPlaceViewModel>
    }
    
    struct Output {
        var shouldKeyboardHide: Signal<Void>
        var pageContentOffset: Driver<CGPoint>
        var progression: Driver<CGFloat>
        var initProgression: Signal<CGFloat>
        var popView: Signal<Void>
        var isContinueButtonEnabled: Signal<Bool>
        var keyboardWithButtonHeight: Signal<CGFloat>
        var showSearchView: Signal<SearchPlaceViewModel>
        var showImagePicker: Signal<Void>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let page$ = BehaviorSubject<Int>(value: 0)
    private let numOfPage$: BehaviorSubject<Int>
    private let continueButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let viewDidAppear$ = PublishSubject<Bool>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    private let categories$ = BehaviorSubject<[HangoutCategory: Bool]>(value: [:])
    private let title$ = BehaviorSubject<String>(value: "")
    private let date$ = BehaviorSubject<Date?>(value: nil)
    private let place$ = BehaviorSubject<Map?>(value: nil)
    private let picture$ = BehaviorSubject<UIImage?>(value: nil)
    private let plan$ = BehaviorSubject<String>(value: "")
    private let language$ = BehaviorSubject<String>(value: "")
    private let openchat$ = BehaviorSubject<String>(value: "")
    private let limit$ = BehaviorSubject<Int?>(value: nil)
    private let isCategoriesValid$ = BehaviorSubject<Bool>(value: false)
    private let isTitleValid$ = BehaviorSubject<Bool>(value: false)
    private let isTimeValid$ = BehaviorSubject<Bool>(value: false)
    private let isPlaceValid$ = BehaviorSubject<Bool>(value: false)
    private let isPictureValid$ = BehaviorSubject<Bool>(value: false)
    private let isPlanValid$ = BehaviorSubject<Bool>(value: false)
    private let isLanguageValid$ = BehaviorSubject<Bool>(value: false)
    private let isOpenchatValid$ = BehaviorSubject<Bool>(value: false)
    private let isLimitValid$ = BehaviorSubject<Bool>(value: false)
    private let showSearchView$ = PublishSubject<SearchPlaceViewModel>()
    private let showImagePicker$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            categoryViewModel: HangoutMakeCategoryViewModel(dependency: dependency.categoryDependency),
            titleViewModel: HangoutMakeTitleViewModel(dependency: dependency.titleDependency),
            timeViewModel: HangoutMakeTimeViewModel(dependency: dependency.timeDependency),
            placeViewModel: HangoutMakePlaceViewModel(dependency: dependency.placeDependency),
            pictureViewModel: HangoutMakePictureViewModel(dependency: dependency.pictureDependency),
            planViewModel: HangoutMakePlanViewModel(dependency: dependency.planDependency),
            languageViewModel: HangoutMakeLanguageViewModel(dependency: dependency.languageDependency),
            openchatViewModel: HangoutMakeOpenchatViewModel(dependency: dependency.openchatDependency),
            limitViewModel: HangoutMakeLimitViewModel(dependency: dependency.limitDependency),
            continueButtonViewModel: ContinueButtonViewModel()
        )
        
        // Streams
        let numOfPage$ = BehaviorSubject<Int>(value: dependency.numOfPage)
        
        let shouldKeyboardHide = Observable
            .merge(continueButtonTapped$, backButtonTapped$)
            .asSignal(onErrorJustReturn: Void())
        let pageContentOffset = page$.map(getContentOffset)
            .asDriver(onErrorJustReturn: .zero)
        let progression = page$.withLatestFrom(numOfPage$.filter { $0 != 0 },
                                                resultSelector: getProgression)
            .asDriver(onErrorJustReturn: .zero)
        let initProgression = viewDidAppear$
            .withLatestFrom(progression)
            .asSignal(onErrorJustReturn: 0)
        let backButtonTappedWithPage = backButtonTapped$
            .withLatestFrom(page$)
            .share()
        let popView = backButtonTappedWithPage
            .filter { $0 == 0 }
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        
        let continueButtonTappedWithPage = continueButtonTapped$
            .withLatestFrom(Observable.combineLatest(page$, numOfPage$))
            .share()
        let isContinueButtonEnabled = Observable
            .merge(
                Observable.combineLatest(
                    page$.filter { $0 >= 0 && $0 <= 4 },
                    isCategoriesValid$, isTitleValid$, isTimeValid$, isPlaceValid$, isPictureValid$,
                    resultSelector: shouldButtonEnabledWithFirst
                ),
                Observable.combineLatest(
                    page$.filter { $0 >= 5 && $0 <= 8 },
                    isPlanValid$, isLanguageValid$, isOpenchatValid$, isLimitValid$,
                    resultSelector: shouldButtonEnabledWithSecond
                )
            )
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        let showSearchView = showSearchView$
            .asSignal(onErrorJustReturn: SearchPlaceViewModel(dependency: dependency.searchPlaceDependency))
        let showImagePicker = showImagePicker$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            continueButtonTapped: continueButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver(),
            viewDidAppear: viewDidAppear$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver(),
            categories: categories$.asObserver(),
            title: title$.asObserver(),
            date: date$.asObserver(),
            place: place$.asObserver(),
            picture: picture$.asObserver(),
            plan: plan$.asObserver(),
            language: language$.asObserver(),
            openchat: openchat$.asObserver(),
            limit: limit$.asObserver(),
            isCategoriesValid: isCategoriesValid$.asObserver(),
            isTitleValid: isTitleValid$.asObserver(),
            isTimeValid: isTimeValid$.asObserver(),
            isPlaceValid: isPlaceValid$.asObserver(),
            isPictureValid: isPictureValid$.asObserver(),
            isPlanValid: isPlanValid$.asObserver(),
            isLanguageValid: isLanguageValid$.asObserver(),
            isOpenchatValid: isOpenchatValid$.asObserver(),
            isLimitValid: isLimitValid$.asObserver(),
            showSearchView: showSearchView$.asObserver()
        )
        
        self.output = Output(
            shouldKeyboardHide: shouldKeyboardHide,
            pageContentOffset: pageContentOffset,
            progression: progression,
            initProgression: initProgression,
            popView: popView,
            isContinueButtonEnabled: isContinueButtonEnabled,
            keyboardWithButtonHeight: keyboardWithButtonHeight,
            showSearchView: showSearchView,
            showImagePicker: showImagePicker
        )
        
        // Bindind
        self.numOfPage$ = numOfPage$
        
        continueButtonTappedWithPage
            .filter { $0.0 + 1 < $0.1 }
            .map { $0.0 + 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        backButtonTappedWithPage
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        // Child(Category)
        subViewModels.categoryViewModel.output.isValid
            .drive(isCategoriesValid$)
            .disposed(by: disposeBag)
        
        // Child(Title)
        keyboardWithButtonHeight
            .emit(to: subViewModels.titleViewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
        
        subViewModels.titleViewModel.output.isValid
            .drive(isTitleValid$)
            .disposed(by: disposeBag)
        
        // Child(Time)
        subViewModels.timeViewModel.output.date
            .distinctUntilChanged()
            .drive(date$)
            .disposed(by: disposeBag)
        
        subViewModels.timeViewModel.output.isValid
            .emit(to: isTimeValid$)
            .disposed(by: disposeBag)
        
        // Child(Place)
        place$
            .compactMap { $0 }
            .bind(to: subViewModels.placeViewModel.input.map)
            .disposed(by: disposeBag)
        
        subViewModels.placeViewModel.output.showSearchView
            .map { _ -> SearchPlaceViewModel in
                let dependency = dependency.searchPlaceDependency
                let viewModel = SearchPlaceViewModel(dependency: dependency)
                viewModel.delegate = self
                return viewModel
            }
            .emit(to: showSearchView$)
            .disposed(by: disposeBag)
        
        subViewModels.placeViewModel.output.isValid
            .emit(to: isPlaceValid$)
            .disposed(by: disposeBag)
        
        // Child(Picture)
        picture$
            .compactMap { $0 }
            .bind(to: subViewModels.pictureViewModel.input.picture)
            .disposed(by: disposeBag)
        
        subViewModels.pictureViewModel.output.pictureButtonTapped
            .emit(to: showImagePicker$)
            .disposed(by: disposeBag)
        
        subViewModels.pictureViewModel.output.isValid
            .emit(to: isPictureValid$)
            .disposed(by: disposeBag)
        
        // Child(Plan)
        keyboardWithButtonHeight
            .emit(to: subViewModels.planViewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
        
        subViewModels.planViewModel.output.isValid
            .emit(to: isPlanValid$)
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

private func getContentOffset(page: Int) -> CGPoint {
    let x = UIScreen.main.bounds.width * CGFloat(page)
    return CGPoint(x: x, y: 0)
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}

private func shouldButtonEnabledWithFirst(page: Int, isCategoryValid: Bool, isTitleValid: Bool, isTimeValid: Bool, isPlaceValid: Bool, isPictureValid: Bool) -> Bool {
    switch page {
    case 0: return isCategoryValid
    case 1: return isTitleValid
    case 2: return isTimeValid
    case 3: return isPlaceValid
    case 4: return isPictureValid
    default: return false}
}

private func shouldButtonEnabledWithSecond(page: Int, isPlanValid: Bool, isLanguageValid: Bool, isOpenchatValid: Bool, isLimitValid: Bool) -> Bool {
    switch page {
    case 5: return isPlanValid
    case 6: return isLanguageValid
    case 7: return isOpenchatValid
    case 8: return isLimitValid
    default: return false}
}

extension HangoutMakeViewModel: SearchPlaceViewModelDelegate {
    func mapSelected(map: Map) {
        place$.onNext(map)
    }
}
