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
    }
    
    struct Dependency {
        var numOfPage: Int
    }
    
    struct Input {
        var page: AnyObserver<Int>
        var numOfPage: AnyObserver<Int>
        var continueButtonTapped: AnyObserver<Void>
        var backButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
//        var shouldKeyboardHide: Signal<Void>
        var pageContentOffset: Driver<CGPoint>
        var progression: Driver<CGFloat>
        var popView: Signal<Void>
//        var isContinueButtonEnabled: Signal<Bool>
        var keyboardWithButtonHeight: Signal<CGFloat>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    let subViewModels: SubViewModels
    
    private let page$: BehaviorSubject<Int>
    private let numOfPage$: BehaviorSubject<Int>
    private let continueButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
        )
        
        // Streams
        let page$ = BehaviorSubject<Int>(value: 0)
        let numOfPage$ = BehaviorSubject<Int>(value: dependency.numOfPage)
        
//        let shouldKeyboardHide = Observable
//            .merge(continueButtonTapped$, backButtonTapped$, nationalityTextFieldTapped$)
//            .asSignal(onErrorJustReturn: Void())
        let pageContentOffset = page$.map(getContentOffset)
            .asDriver(onErrorJustReturn: .zero)
        let progression = page$.withLatestFrom(numOfPage$.filter { $0 != 0 },
                                                resultSelector: getProgression)
            .asDriver(onErrorJustReturn: .zero)
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
//        let isContinueButtonEnabled = Observable
//            .combineLatest(page$, isNameValid$, isGenderValid$, isBirthValid$, isNationalityValid$)
//            .map(shouldButtonEnabled)
//            .distinctUntilChanged()
//            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        
        // Input & Output
        self.input = Input(
            page: page$.asObserver(),
            numOfPage: numOfPage$.asObserver(),
            continueButtonTapped: continueButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver()
//            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver()
        )
        
        self.output = Output(
//            shouldKeyboardHide: shouldKeyboardHide,
            pageContentOffset: pageContentOffset,
            progression: progression,
            popView: popView,
//            isContinueButtonEnabled: isContinueButtonEnabled,
            keyboardWithButtonHeight: keyboardWithButtonHeight
        )
        
        // Binding
        self.page$ = page$
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
        
        // NameView
//        keyboardWithButtonHeight
//            .emit(to: subViewModels.nameViewModel.input.keyboardWithButtonHeight)
//            .disposed(by: disposeBag)
        
//        subViewModels.nameViewModel.output.modifiedName
//            .emit(to: name$)
//            .disposed(by: disposeBag)
        
//        subViewModels.nameViewModel.output.isValid
//            .drive(isNameValid$)
//            .disposed(by: disposeBag)
        
        // GenderView
//        subViewModels.genderViewModel.output.gender
//            .emit(to: gender$)
//            .disposed(by: disposeBag)
        
//        subViewModels.genderViewModel.output.isValid
//            .drive(isGenderValid$)
//            .disposed(by: disposeBag)
        
        // BirthView
//        subViewModels.birthViewModel.output.isValid
//            .drive(isBirthValid$)
//            .disposed(by: disposeBag)
        
        // NationalityView
//        country
//            .emit(to: subViewModels.nationalityViewModel.input.country)
//            .disposed(by: disposeBag)
        
//        subViewModels.nationalityViewModel.output.textFieldTapped
//            .emit(to: nationalityTextFieldTapped$)
//            .disposed(by: disposeBag)
        
//        subViewModels.nationalityViewModel.output.isValid
//            .drive(isNationalityValid$)
//            .disposed(by: disposeBag)
        
        // ContinueButton
//        output.isContinueButtonEnabled
//            .emit(to: subViewModels.continueButtonViewModel.input.isButtonEnabled)
//            .disposed(by: disposeBag)
        
//        subViewModels.continueButtonViewModel.output.continueButtonTapped
//            .emit(to: continueButtonTapped$)
//            .disposed(by: disposeBag)
        
        // SelectNationalityView
//        subViewModels.selectNationalityViewModel.output.country
//            .emit(to: country$)
//            .disposed(by: disposeBag)
    }
}

private func getContentOffset(page: Int) -> CGPoint {
    let x = UIScreen.main.bounds.width * CGFloat(page)
    return CGPoint(x: x, y: 0)
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}

private func shouldButtonEnabled(page: Int, isNameValid: Bool, isGenderValid: Bool, isBirthValid: Bool, isNationalityValid: Bool) -> Bool {
    switch page {
    case 0: return isNameValid
    case 1: return isGenderValid
    case 2: return isBirthValid
    case 3: return isNationalityValid
    default: return false
    }
}

