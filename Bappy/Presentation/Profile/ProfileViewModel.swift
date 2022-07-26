//
//  ProfileViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/29.
//

import UIKit
import RxSwift
import RxCocoa

enum ProfileAuthorization { case view, edit }

final class ProfileViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        let authorization: ProfileAuthorization
        let bappyAuthRepository: BappyAuthRepository
    }
    
    struct SubViewModels {
        let headerViewModel: ProfileHeaderViewModel
    }
    
    struct Input {
        var scrollToTop: AnyObserver<Void> // <-> Parent
        var viewWillAppear: AnyObserver<Bool> // <-> View
        var settingButtonTapped: AnyObserver<Void> // <-> View
        var selectedButtonIndex: AnyObserver<Int> // <-> Child
        var moreButtonTapped: AnyObserver<Void> // <-> Child
    }
    
    struct Output {
        var scrollToTop: Signal<Void> // <-> View
        var hideSettingButton: Signal<Bool> // <-> View
        var hangouts: Driver<[Hangout]> // <-> View
        var showSettingView: Signal<ProfileSettingViewModel?> // <-> View
        var showDetailView: Signal<ProfileDetailViewModel?> // <-> View
        var showAlert: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let user$: BehaviorSubject<BappyUser>
    private let authorization$: BehaviorSubject<ProfileAuthorization>
    private let hangouts$ = BehaviorSubject<[Hangout]>(value: [])
    
    private let scrollToTop$ = PublishSubject<Void>()
    private let viewWillAppear$ = PublishSubject<Bool>()
    private let selectedButtonIndex$ = PublishSubject<Int>()
    private let settingButtonTapped$ = PublishSubject<Void>()
    private let moreButtonTapped$ = PublishSubject<Void>()
    
    private let showSettingView$ = PublishSubject<ProfileSettingViewModel?>()
    private let showDetailView$ = PublishSubject<ProfileDetailViewModel?>()
    private let showAlert$ = PublishSubject<Void>()
    
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
        let authorization$ = BehaviorSubject<ProfileAuthorization>(value: dependency.authorization)
        
        let scrollToTop = scrollToTop$
            .asSignal(onErrorJustReturn: Void())
        let hideSettingButton = authorization$
            .map { $0 == .view }
            .asSignal(onErrorJustReturn: true)
        let hangouts = hangouts$
            .asDriver(onErrorJustReturn: [])
        let showSettingView = showSettingView$
            .asSignal(onErrorJustReturn: nil)
        let showDetailView = showDetailView$
            .asSignal(onErrorJustReturn: nil)
        let showAlert = showAlert$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            scrollToTop: scrollToTop$.asObserver(),
            viewWillAppear: viewWillAppear$.asObserver(),
            settingButtonTapped: settingButtonTapped$.asObserver(),
            selectedButtonIndex: selectedButtonIndex$.asObserver(),
            moreButtonTapped: moreButtonTapped$.asObserver()
        )
        
        self.output = Output(
            scrollToTop: scrollToTop,
            hideSettingButton: hideSettingButton,
            hangouts: hangouts,
            showSettingView: showSettingView,
            showDetailView: showDetailView,
            showAlert: showAlert
        )
        
        // Bindind
        self.user$ = user$
        self.authorization$ = authorization$
        
        viewWillAppear$
            .take(1)
            .withLatestFrom(user$)
            .map(\.state)
            .filter { $0 == .anonymous }
            .map { _ in }
            .bind(to: showAlert$)
            .disposed(by: disposeBag)
        
        settingButtonTapped$
            .map { _ -> ProfileSettingViewModel in
                let dependency = ProfileSettingViewModel.Dependency(
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: DefaultFirebaseRepository.shared)
                return ProfileSettingViewModel(dependency: dependency)
            }
            .bind(to: showSettingView$)
            .disposed(by: disposeBag)
        
        moreButtonTapped$
            .withLatestFrom(user$)
            .map { user -> ProfileDetailViewModel in
                let dependency = ProfileDetailViewModel.Dependency(
                    user: user,
                    authorization: dependency.authorization,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return ProfileDetailViewModel(dependency: dependency)
            }
            .bind(to: showDetailView$)
            .disposed(by: disposeBag)
        
        // Child(HeaderView)
        user$
            .bind(to: subViewModels.headerViewModel.input.user)
            .disposed(by: disposeBag)
        
        subViewModels.headerViewModel.output.moreButtonTapped
            .emit(to: moreButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.headerViewModel.output.selectedIndex
            .emit(to: selectedButtonIndex$)
            .disposed(by: disposeBag)
    }
}
