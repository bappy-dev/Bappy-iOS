//
//  RegisterViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/15.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
        var numOfPage: Int
        var isButtonEnabled: Bool
        var nameDependency: RegisterNameViewModel.Dependency
        var birthDependency: RegisterBirthViewModel.Dependency
        var country: Country
        var selectnationalityDependency: SelectNationalityViewModel.Dependency
    }
    
    struct SubViewModels {
        let nameViewModel: RegisterNameViewModel
        let genderViewModel: RegisterGenderViewModel
        let birthViewModel: RegisterBirthViewModel
        let nationalityViewModel: RegisterNationalityViewModel
        let continueButtonViewModel: ContinueButtonViewModel
        let selectNationalityViewModel: SelectNationalityViewModel
    }
    
    struct Input {
        var continueButtonTapped: AnyObserver<Void> // <-> Child(continueButton)
        var backButtonTapped: AnyObserver<Void> // <-> View
        var name: AnyObserver<String?> // <-> Child(Name)
        var gender: AnyObserver<Gender?> // <-> Child(Gender)
        var birth: AnyObserver<Date?> // <-> Child(Birth)
        var country: AnyObserver<Country?> // <-> Child(Country)
        var isNameValid: AnyObserver<Bool> // <-> Child(Name)
        var isGenderValid: AnyObserver<Bool> // <-> Child(Gender)
        var isBirthValid: AnyObserver<Bool> // <-> Child(Birth)
        var isNationalityValid: AnyObserver<Bool> // <-> Child(Country)
        var keyboardWithButtonHeight: AnyObserver<CGFloat> // <-> View
        var nationalityTextFieldTapped: AnyObserver<Void> // <-> Child(Country)
        var viewDidAppear: AnyObserver<Bool> // <-> View
    }
    
    struct Output {
        var shouldKeyboardHide: Signal<Void> // <-> View
        var pageContentOffset: Driver<CGPoint> // <-> View
        var progression: Driver<CGFloat> // <-> View
        var initProgression: Signal<CGFloat> // <-> View
        var popView: Signal<Void> // <-> View
        var showCompleteView: PublishSubject<RegisterCompletedViewModel> // <-> View
        var isContinueButtonEnabled: Signal<Bool> // <-> Child(ContinueButton)
        var keyboardWithButtonHeight: Signal<CGFloat> // <-> Child(Name)
        var country: Signal<Country> // <-> Child(Country)
        var showSelectNationalityView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let page$: BehaviorSubject<Int>
    private let numOfPage$: BehaviorSubject<Int>
    private let showCompleteView$ = PublishSubject<RegisterCompletedViewModel>()
    
    private let continueButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let name$ = BehaviorSubject<String?>(value: nil)
    private let gender$ = BehaviorSubject<Gender?>(value: nil)
    private let birth$ = BehaviorSubject<Date?>(value: nil)
    private let country$ = BehaviorSubject<Country?>(value: nil)
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
            selectNationalityViewModel: SelectNationalityViewModel(dependency: dependency.selectnationalityDependency)
        )
        
        // Streams
        let page$ = BehaviorSubject<Int>(value: 0)
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
        let isContinueButtonEnabled = Observable
            .combineLatest(page$, isNameValid$, isGenderValid$, isBirthValid$, isNationalityValid$)
            .map(shouldButtonEnabled)
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        let country = country$
            .compactMap { $0 }
            .asSignal(onErrorJustReturn: dependency.country)
        let showSelectNationalityView = nationalityTextFieldTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
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
            showCompleteView: showCompleteView$,
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
        
        subViewModels.birthViewModel.output.selectedDate
            .bind(to: birth$)
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
        
        // CompltedView
        let result = continueButtonTappedWithPage
            .filter { $0.0 + 1 == $0.1 }
            .withLatestFrom(Observable.combineLatest(
                name$.compactMap { $0 },
                gender$.compactMap { $0 },
                birth$.compactMap { $0 },
                country$.compactMap { $0 }
            ))
            .withLatestFrom(dependency.firebaseRepository.token.compactMap { $0 }) {
                dependency.bappyAuthRepository.createUser(
                    name: $0.0, gender: $0.1.rawValue,
                    birth: $0.2.toString(dateFormat: "yyyy.MM.dd"),
                    country: "\($0.3.name)/\($0.3.code)",
                    token: $1)
            }
            .flatMap { $0 }
            .share()
        
        result
            .compactMap(getUserError)
            .bind(onNext: { print("ERROR: \($0)") })
            .disposed(by: disposeBag)
        
        result
            .compactMap(getUser)
            .map { user -> RegisterCompletedViewModel in
                let dependency = RegisterCompletedViewModel.Dependency(
                    user: user,
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: dependency.firebaseRepository
                )
                return RegisterCompletedViewModel(dependency: dependency)
            }
            .bind(to: showCompleteView$)
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

private func getUser(_ result: Result<BappyUser, Error>) -> BappyUser? {
    guard case .success(let value) = result else { return nil }
    return value
}

private func getUserError(_ result: Result<BappyUser, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}
