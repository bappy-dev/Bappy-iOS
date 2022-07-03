//
//  ProfileViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
    }
    
    struct SubViewModels {
        let headerViewModel: ProfileHeaderViewModel
    }
    
    struct Input {
        var settingButtonTapped: AnyObserver<Void> // <-> View
        var selectedButtonIndex: AnyObserver<Int> // <-> Child
        var moreButtonTapped: AnyObserver<Void> // <-> Child
    }
    
    struct Output {
        var hideSettingButton: Signal<Bool> // <-> View
        var hangouts: Driver<[Hangout]> // <-> View
        var showSettingView: PublishSubject<ProfileSettingViewModel> // <-> View
        var showDetailView: PublishSubject<ProfileDetailViewModel> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let user$: BehaviorSubject<BappyUser>
    private let currentUser$: BehaviorSubject<BappyUser?>
    private let hangouts$ = BehaviorSubject<[Hangout]>(value: [])
    
    private let selectedButtonIndex$ = PublishSubject<Int>()
    private let settingButtonTapped$ = PublishSubject<Void>()
    private let moreButtonTapped$ = PublishSubject<Void>()
    
    private let showSettingView$ = PublishSubject<ProfileSettingViewModel>()
    private let showDetailView$ = PublishSubject<ProfileDetailViewModel>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            headerViewModel: ProfileHeaderViewModel(
                dependency: .init(
                    user: dependency.user,
                    bappyAuthRepository: dependency.bappyAuthRepository
                )
            )
        )
        
        // Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        let currentUser$ = dependency.bappyAuthRepository.currentUser
        
        let hideSettingButton = Observable
            .combineLatest(user$, currentUser$.compactMap { $0 })
            .map { $0.0 != $0.1 }
            .startWith(true)
            .asSignal(onErrorJustReturn: true)
        let hangouts = hangouts$
            .asDriver(onErrorJustReturn: [])
        
        // Input & Output
        self.input = Input(
            settingButtonTapped: settingButtonTapped$.asObserver(),
            selectedButtonIndex: selectedButtonIndex$.asObserver(),
            moreButtonTapped: moreButtonTapped$.asObserver()
        )
        
        self.output = Output(
            hideSettingButton: hideSettingButton,
            hangouts: hangouts,
            showSettingView: showSettingView$,
            showDetailView: showDetailView$
        )
        
        // Bindind
        self.user$ = user$
        self.currentUser$ = currentUser$
        
        settingButtonTapped$
            .map { _ -> ProfileSettingViewModel in
                let dependency = ProfileSettingViewModel.Dependency(
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: dependency.firebaseRepository)
                return ProfileSettingViewModel(dependency: dependency)
            }
            .bind(to: showSettingView$)
            .disposed(by: disposeBag)
        
        moreButtonTapped$
            .map { _ -> ProfileDetailViewModel in
                let dependency = ProfileDetailViewModel.Dependency(
                    user: dependency.user,
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: dependency.firebaseRepository)
                return ProfileDetailViewModel(dependency: dependency)
            }
            .bind(to: showDetailView$)
            .disposed(by: disposeBag)
        
        // Child(HeaderView)
        subViewModels.headerViewModel.output.moreButtonTapped
            .emit(to: moreButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.headerViewModel.output.selectedIndex
            .emit(to: selectedButtonIndex$)
            .disposed(by: disposeBag)
    }
}
