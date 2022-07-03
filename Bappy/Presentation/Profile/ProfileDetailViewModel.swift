//
//  ProfileDetailViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/02.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
    }
    
    struct SubViewModels {
        let mainViewModel: ProfileDetailMainViewModel
        let introduceViewModel: ProfileDetailIntroduceViewModel
        let affiliationViewModel: ProfileDetailAffiliationViewModel
        let languageViewModel: ProfileDetailLanguageViewModel
        let personalityViewModel: ProfileDetailPersonalityViewModel
        let interestsViewModel: ProfileDetailInterestsViewModel
    }
    
    struct Input {
        var editButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var hideEditButton: Signal<Bool> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let user$: BehaviorSubject<BappyUser>
    private let currentUser$: BehaviorSubject<BappyUser?>
    
    private let editButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            mainViewModel: ProfileDetailMainViewModel(
                dependency: .init(user: dependency.user)),
            introduceViewModel: ProfileDetailIntroduceViewModel(
                dependency: .init(user: dependency.user)),
            affiliationViewModel: ProfileDetailAffiliationViewModel(
                dependency: .init(user: dependency.user)),
            languageViewModel: ProfileDetailLanguageViewModel(
                dependency: .init(user: dependency.user)),
            personalityViewModel: ProfileDetailPersonalityViewModel(
                dependency: .init(user: dependency.user)),
            interestsViewModel: ProfileDetailInterestsViewModel(
                dependency: .init(user: dependency.user))
        )
        
        // Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        
        let hideEditButton = Observable
            .combineLatest(user$, currentUser$.compactMap { $0 })
            .map { $0.0 != $0.1 }
            .startWith(true)
            .asSignal(onErrorJustReturn: true)
        
        // Input & Output
        self.input = Input(
            editButtonTapped: editButtonTapped$.asObserver()
        )
        
        self.output = Output(
            hideEditButton: hideEditButton
        )
        
        // Bindind
        self.user$ = user$
        self.currentUser$ = currentUser$
    }
}
