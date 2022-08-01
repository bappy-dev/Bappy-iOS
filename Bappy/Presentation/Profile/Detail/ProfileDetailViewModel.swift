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
        let authorization: ProfileAuthorization
        let bappyAuthRepository: BappyAuthRepository
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
        var backButtonTapped: AnyObserver<Void> // <-> View
        var editButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var popView: Signal<Void> // <-> View
        var hideEditButton: Driver<Bool> // <-> View
        var showEditView: Signal<ProfileEditViewModel?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let user$: BehaviorSubject<BappyUser>
    private let authorization$: BehaviorSubject<ProfileAuthorization>
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let editButtonTapped$ = PublishSubject<Void>()
    private let showEditView$ = PublishSubject<ProfileEditViewModel?>()
  
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
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        let authorization$ = BehaviorSubject<ProfileAuthorization>(value: dependency.authorization)
        
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let hideEditButton = authorization$
            .map { $0 == .view }
            .asDriver(onErrorJustReturn: true)
        let showEditView = showEditView$
            .asSignal(onErrorJustReturn: nil)
            
        // MARK: Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            editButtonTapped: editButtonTapped$.asObserver()
        )
        
        self.output = Output(
            popView: popView,
            hideEditButton: hideEditButton,
            showEditView: showEditView
        )
        
        // MARK: Bindind
        self.user$ = user$
        self.authorization$ = authorization$
        
        editButtonTapped$
            .map { _ -> ProfileEditViewModel in
                let dependency = ProfileEditViewModel.Dependency(
                    user: dependency.user,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return .init(dependency: dependency)
            }
            .bind(to: showEditView$)
            .disposed(by: disposeBag)
    }
}
