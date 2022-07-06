//
//  ProfileEditViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
    }
    
    struct SubViewModels {
        let mainViewModel: ProfileEditMainViewModel
        let introduceViewModel: ProfileEditIntroduceViewModel
        let affiliationViewModel: ProfileEditAffiliationViewModel
        let languageViewModel: ProfileEditLanguageViewModel
        let personalityViewModel: ProfileEditPersonalityViewModel
        let interestsViewModel: ProfileEditInterestsViewModel
    }
    
    struct Input {
        var image: AnyObserver<UIImage?> // <-> View
        var saveButtonTapped: AnyObserver<Void> // <-> View
        var backButtonTapped: AnyObserver<Void> // <-> View
        var imageButtonTapped: AnyObserver<Void> // <-> Child(Main)
        var languageDidBeginEditing: AnyObserver<Void> // <-> Child(Language)
    }
    
    struct Output {
        var image: Signal<UIImage?> // <-> Child(Main)
        var selectedLanguages: Signal<[Language]?> // <-> Child(Language)
        var popView: Signal<Void> // <-> View
        var hideEditButton: Signal<Bool> // <-> View
        var showImagePicker: Signal<Void> // <-> View
        var showLanguageView: Signal<ProfileLanguageViewModel?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let user$: BehaviorSubject<BappyUser>
    private let currentUser$: BehaviorSubject<BappyUser?>
    private let userLanguages$: BehaviorSubject<[Language]>
    private let selectedLanguages$ = BehaviorSubject<[Language]?>(value: nil)
    
    private let image$ = BehaviorSubject<UIImage?>(value: nil)
    private let saveButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let imageButtonTapped$ = PublishSubject<Void>()
    private let languageDidBeginEditing$ = PublishSubject<Void>()
    
    private let showLanguageView$ = PublishSubject<ProfileLanguageViewModel?>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            mainViewModel: ProfileEditMainViewModel(
                dependency: .init(user: dependency.user)),
            introduceViewModel: ProfileEditIntroduceViewModel(
                dependency: .init(user: dependency.user)),
            affiliationViewModel: ProfileEditAffiliationViewModel(
                dependency: .init(user: dependency.user)),
            languageViewModel: ProfileEditLanguageViewModel(
                dependency: .init(user: dependency.user)),
            personalityViewModel: ProfileEditPersonalityViewModel(
                dependency: .init(user: dependency.user)),
            interestsViewModel: ProfileEditInterestsViewModel(
                dependency: .init(user: dependency.user))
        )
        
        // Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        let userLanguages$ = BehaviorSubject<[Language]>(value: dependency.user.languages ?? [])
        
        let image = image$
            .asSignal(onErrorJustReturn: nil)
        let selectedLanguages = selectedLanguages$
            .asSignal(onErrorJustReturn: nil)
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let hideEditButton = Observable
            .combineLatest(user$, currentUser$.compactMap { $0 })
            .map { $0.0 != $0.1 }
            .startWith(true)
            .asSignal(onErrorJustReturn: true)
        let showImagePicker = imageButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showLanguageView = showLanguageView$
            .asSignal(onErrorJustReturn: nil)
        
        // Input & Output
        self.input = Input(
            image: image$.asObserver(),
            saveButtonTapped: saveButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver(),
            imageButtonTapped: imageButtonTapped$.asObserver(),
            languageDidBeginEditing: languageDidBeginEditing$.asObserver()
        )
        
        self.output = Output(
            image: image,
            selectedLanguages: selectedLanguages,
            popView: popView,
            hideEditButton: hideEditButton,
            showImagePicker: showImagePicker,
            showLanguageView: showLanguageView
        )
        
        // Bindind
        self.user$ = user$
        self.currentUser$ = currentUser$
        self.userLanguages$ = userLanguages$
        
        languageDidBeginEditing$
            .withLatestFrom(selectedLanguages$)
            .withLatestFrom(userLanguages$) { selectedLanguages, languages -> ProfileLanguageViewModel in
                let languages = selectedLanguages ?? languages
                let dependency = ProfileLanguageViewModel.Dependency(
                    userLanguages: languages)
                let viewModel = ProfileLanguageViewModel(dependency: dependency)
                viewModel.delegate = self
                return viewModel
            }
            .bind(to: showLanguageView$)
            .disposed(by: disposeBag)
        
        // Child(Main)
        image
            .emit(to: subViewModels.mainViewModel.input.image)
            .disposed(by: disposeBag)
            
        
        subViewModels.mainViewModel.output.imageButtonTapped
            .emit(to: imageButtonTapped$)
            .disposed(by: disposeBag)
        
        // Child(Language)
        selectedLanguages$
            .bind(to: subViewModels.languageViewModel.input.selectedLanguages)
            .disposed(by: disposeBag)
        
        subViewModels.languageViewModel.output.didBeginEditing
            .emit(to: languageDidBeginEditing$)
            .disposed(by: disposeBag)
    }
}

// MARK: - ProfileLanguageViewModelDelegate
extension ProfileEditViewModel: ProfileLanguageViewModelDelegate {
    func selectedLanguages(_ languages: [Language]) {
        selectedLanguages$.onNext(languages)
    }
}
