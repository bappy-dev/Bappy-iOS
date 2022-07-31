//
//  BappyTabBarViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import UIKit
import RxSwift
import RxCocoa

final class BappyTabBarViewModel: ViewModelType {
    
    struct Dependency {
        var selectedIndex: Int
        var user: BappyUser
        var bappyAuthRepository: BappyAuthRepository
    }
    
    struct SubViewModels {
        let homeListViewModel: HomeListViewModel
        let profileViewModel: ProfileViewModel
    }
    
    struct Input {
        var homeButtonTapped: AnyObserver<Void> // <-> View
        var profileButtonTapped: AnyObserver<Void> // <-> View
        var writeButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var seletedIndex: Driver<Int> // <-> View
        var isHomeButtonSelected: Driver<Bool> // <-> View
        var isProfileButtonSelected: Driver<Bool> // <-> View
        var showWriteView: Signal<HangoutMakeViewModel?> // <-> View
        var showSignInAlert: Signal<String?> // <-> View
        var scrollToTopInHome: Signal<Void> // <-> Child(Home)
        var scrollToTopInProfile: Signal<Void> // <-> Child(Profile)
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let currentUser$: BehaviorSubject<BappyUser>
    private let selectedIndex$: BehaviorSubject<Int>
    private let popToSelectedRootView$ = PublishSubject<Void>()
    
    private let homeButtonTapped$ = PublishSubject<Void>()
    private let profileButtonTapped$ = PublishSubject<Void>()
    private let writeButtonTapped$ = PublishSubject<Void>()
    private let scrollToTopInHome$ = PublishSubject<Void>()
    private let scrollToTopInProfile$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            homeListViewModel: HomeListViewModel(dependency: .init(
                bappyAuthRepository: dependency.bappyAuthRepository,
                hangoutRepository: DefaultHangoutRepository(),
                locationRepository: DefaultLocationRepository.shared)
            ),
            profileViewModel: ProfileViewModel(dependency: .init(
                user: dependency.user,
                authorization: .edit,
                bappyAuthRepository: dependency.bappyAuthRepository)
            )
        )
        
        // Streams
        let currentUser$ = BehaviorSubject<BappyUser>(value: dependency.user)
        let selectedIndex$ = BehaviorSubject<Int>(value: dependency.selectedIndex)
        
        let selectedIndex = selectedIndex$
            .asDriver(onErrorJustReturn: 0)
        let isHomeButtonSelected = selectedIndex$
            .map { $0 == 0 }
            .asDriver(onErrorJustReturn: true)
        let isProfileButtonSelected = selectedIndex$
            .map { $0 == 1 }
            .asDriver(onErrorJustReturn: true)
        let showWriteView = writeButtonTapped$
            .withLatestFrom(currentUser$)
            .filter { $0.state == .normal }
            .map { user -> HangoutMakeViewModel in
                let dependency = HangoutMakeViewModel.Dependency(
                    googleMapImageRepository: DefaultGoogleMapImageRepository(),
                    currentUser: user)
                return HangoutMakeViewModel(dependency: dependency)}
            .asSignal(onErrorJustReturn: nil)
        let showSignInAlert = writeButtonTapped$
            .withLatestFrom(currentUser$)
            .filter { $0.state == .anonymous }
            .map { _ in "Sign in and make\na new hangout!" }
            .asSignal(onErrorJustReturn: nil)
        let scrollToTopInHome = scrollToTopInHome$
            .asSignal(onErrorJustReturn: Void())
        let scrollToTopInProfile = scrollToTopInProfile$
            .asSignal(onErrorJustReturn: Void())

        // Input & Output
        self.input = Input(
            homeButtonTapped: homeButtonTapped$.asObserver(),
            profileButtonTapped: profileButtonTapped$.asObserver(),
            writeButtonTapped: writeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            seletedIndex: selectedIndex,
            isHomeButtonSelected: isHomeButtonSelected,
            isProfileButtonSelected: isProfileButtonSelected,
            showWriteView: showWriteView,
            showSignInAlert: showSignInAlert,
            scrollToTopInHome: scrollToTopInHome,
            scrollToTopInProfile: scrollToTopInProfile
        )
        
        // Binding
        self.currentUser$ = currentUser$
        self.selectedIndex$ = selectedIndex$
        
        homeButtonTapped$
            .withLatestFrom(selectedIndex)
            .do(onNext: { _ in self.selectedIndex$.onNext(0) })
            .filter { $0 == 0 }
            .map { _ in }
            .bind(to: scrollToTopInHome$)
            .disposed(by: disposeBag)
        
        profileButtonTapped$
            .withLatestFrom(selectedIndex)
            .do(onNext: { _ in self.selectedIndex$.onNext(1) })
            .filter { $0 == 1 }
            .map { _ in }
            .bind(to: scrollToTopInProfile$)
            .disposed(by: disposeBag)
        
        // Child(Home)
        scrollToTopInHome
            .emit(to: subViewModels.homeListViewModel.input.scrollToTop)
            .disposed(by: disposeBag)
        
        // Child(Profile)
        scrollToTopInProfile
            .emit(to: subViewModels.profileViewModel.input.scrollToTop)
            .disposed(by: disposeBag)
    }
}
