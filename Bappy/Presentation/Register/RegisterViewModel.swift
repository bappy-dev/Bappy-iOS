//
//  RegisterViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/15.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

final class RegisterViewModel: ViewModelType {
    
    struct SubViewModels {
        let nameViewModel: RegisterNameViewModel
        let genderViewModel: RegisterGenderViewModel
        let birthViewModel: RegisterBirthViewModel
        let nationalityViewModel: RegisterNationalityViewModel
        let continueButtonViewModel: ContinueButtonViewModel
        let progressBarViewModel: ProgressBarViewModel
        let selectNationalityViewModel: SelectNationalityViewModel
        let completedViewModel: RegisterCompletedViewModel
    }
    
    struct Dependency {
        var page: Int
        var numOfPage: Int
        var isButtonEnabled: Bool
        var nameDependency: RegisterNameViewModel.Dependency
        var birthDependency: RegisterBirthViewModel.Dependency
        var country: Country
        var selectnationalityDependency: SelectNationalityViewModel.Dependency
    }
    
    struct Input {
        var page: AnyObserver<Int>
        var numOfPage: AnyObserver<Int>
        var continueButtonTapped: AnyObserver<Void>
        var backButtonTapped: AnyObserver<Void>
        var name: AnyObserver<String>
        var gender: AnyObserver<Gender>
        var birth: AnyObserver<String>
        var country: AnyObserver<Country>
        var isNameValid: AnyObserver<Bool>
        var isGenderValid: AnyObserver<Bool>
        var isBirthValid: AnyObserver<Bool>
        var isNationalityValid: AnyObserver<Bool>
        var keyboardWithButtonHeight: AnyObserver<CGFloat>
        var nationalityTextFieldTapped: AnyObserver<Void>
        var viewDidAppear: AnyObserver<Bool>
    }
    
    struct Output {
        var shouldKeyboardHide: Signal<Void>
        var pageContentOffset: Driver<CGPoint>
        var progression: Driver<CGFloat>
        var initProgression: Signal<CGFloat>
        var popView: Signal<Void>
        var showCompleteView: Signal<Void>
        var isContinueButtonEnabled: Signal<Bool>
        var keyboardWithButtonHeight: Signal<CGFloat>
        var country: Signal<Country>
        var showSelectNationalityView: Signal<Void>
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
    private let name$ = PublishSubject<String>()
    private let gender$ = PublishSubject<Gender>()
    private let birth$ = PublishSubject<String>()
    private let country$ = PublishSubject<Country>()
    private let isNameValid$ = BehaviorSubject<Bool>(value: false)
    private let isGenderValid$ = BehaviorSubject<Bool>(value: false)
    private let isBirthValid$ = BehaviorSubject<Bool>(value: false)
    private let isNationalityValid$ = BehaviorSubject<Bool>(value: false)
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    private let nationalityTextFieldTapped$ = PublishSubject<Void>()
    private let viewDidAppear$ = PublishSubject<Bool>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            nameViewModel: RegisterNameViewModel(dependency: dependency.nameDependency),
            genderViewModel: RegisterGenderViewModel(),
            birthViewModel: RegisterBirthViewModel(dependency: dependency.birthDependency),
            nationalityViewModel: RegisterNationalityViewModel(dependency: .init(country: dependency.country)),
            continueButtonViewModel: ContinueButtonViewModel(),
            progressBarViewModel: ProgressBarViewModel(),
            selectNationalityViewModel: SelectNationalityViewModel(dependency: dependency.selectnationalityDependency),
            completedViewModel: RegisterCompletedViewModel()
        )
        
        // Streams
        let page$ = BehaviorSubject<Int>(value: dependency.page)
        let numOfPage$ = BehaviorSubject<Int>(value: dependency.numOfPage)
        
        let shouldKeyboardHide = Observable
            .merge(continueButtonTapped$, backButtonTapped$, nationalityTextFieldTapped$)
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
        
        let showCompleteView = continueButtonTappedWithPage
            .filter { $0.0 + 1 == $0.1 }
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        let isContinueButtonEnabled = Observable
            .combineLatest(page$, isNameValid$, isGenderValid$, isBirthValid$, isNationalityValid$)
            .map(shouldButtonEnabled)
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        let country = country$
            .asSignal(onErrorJustReturn: dependency.country)
        let showSelectNationalityView = nationalityTextFieldTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            page: page$.asObserver(),
            numOfPage: numOfPage$.asObserver(),
            continueButtonTapped: continueButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver(),
            name: name$.asObserver(),
            gender: gender$.asObserver(),
            birth: birth$.asObserver(),
            country: country$.asObserver(),
            isNameValid: isNameValid$.asObserver(),
            isGenderValid: isGenderValid$.asObserver(),
            isBirthValid: isBirthValid$.asObserver(),
            isNationalityValid: isNationalityValid$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver(),
            nationalityTextFieldTapped: nationalityTextFieldTapped$.asObserver(),
            viewDidAppear: viewDidAppear$.asObserver()
        )
        
        self.output = Output(
            shouldKeyboardHide: shouldKeyboardHide,
            pageContentOffset: pageContentOffset,
            progression: progression,
            initProgression: initProgression,
            popView: popView,
            showCompleteView: showCompleteView,
            isContinueButtonEnabled: isContinueButtonEnabled,
            keyboardWithButtonHeight: keyboardWithButtonHeight,
            country: country,
            showSelectNationalityView: showSelectNationalityView
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
        keyboardWithButtonHeight
            .emit(to: subViewModels.nameViewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
        
        subViewModels.nameViewModel.output.modifiedName
            .emit(to: name$)
            .disposed(by: disposeBag)
        
        subViewModels.nameViewModel.output.isValid
            .drive(isNameValid$)
            .disposed(by: disposeBag)
        
        // GenderView
        subViewModels.genderViewModel.output.gender
            .emit(to: gender$)
            .disposed(by: disposeBag)
        
        subViewModels.genderViewModel.output.isValid
            .drive(isGenderValid$)
            .disposed(by: disposeBag)
        
        // BirthView
        subViewModels.birthViewModel.output.isValid
            .drive(isBirthValid$)
            .disposed(by: disposeBag)
        
        // NationalityView
        country
            .emit(to: subViewModels.nationalityViewModel.input.country)
            .disposed(by: disposeBag)
        
        subViewModels.nationalityViewModel.output.textFieldTapped
            .emit(to: nationalityTextFieldTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.nationalityViewModel.output.isValid
            .drive(isNationalityValid$)
            .disposed(by: disposeBag)
        
        // ContinueButton
        output.isContinueButtonEnabled
            .emit(to: subViewModels.continueButtonViewModel.input.isButtonEnabled)
            .disposed(by: disposeBag)
        
        subViewModels.continueButtonViewModel.output.continueButtonTapped
            .emit(to: continueButtonTapped$)
            .disposed(by: disposeBag)
        
        // SelectNationalityView
        subViewModels.selectNationalityViewModel.output.country
            .emit(to: country$)
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

private func shouldButtonEnabled(page: Int, isNameValid: Bool, isGenderValid: Bool, isBirthValid: Bool, isNationalityValid: Bool) -> Bool {
    switch page {
    case 0: return isNameValid
    case 1: return isGenderValid
    case 2: return isBirthValid
    case 3: return isNationalityValid
    default: return false
    }
}
