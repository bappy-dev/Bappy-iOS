//
//  ProfileSettingViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/02.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSettingViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let firebaseRepository: FirebaseRepository
        
        init(bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared,
             firebaseRepository: FirebaseRepository = DefaultFirebaseRepository.shared) {
            self.bappyAuthRepository = bappyAuthRepository
            self.firebaseRepository = firebaseRepository
        }
    }
    
    struct SubViewModels {
        let notificationViewModel: ProfileSettingNotificationViewModel
        let serviceViewModel: ProfileSettingServiceViewModel
    }
    
    struct Input {
        var backButtonTapped: AnyObserver<Void> // <-> View
        var serviceButtonTapped: AnyObserver<Void> // <-> Child(Service)
        var logoutButtonTapped: AnyObserver<Void> // <-> Child(Service)
        var deleteAccountButtonTapped: AnyObserver<Void> // <-> Child(Service)
    }
    
    struct Output {
        var showServiceView: Signal<Void> // <-> View
        var switchToSignInView: Signal<BappyLoginViewModel?> // <-> View
        var showDeleteAccountView: Signal<DeleteAccountViewModel?> // <-> View
        var popView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let serviceButtonTapped$ = PublishSubject<Void>()
    private let logoutButtonTapped$ = PublishSubject<Void>()
    private let deleteAccountButtonTapped$ = PublishSubject<Void>()
    
    private let switchToSignInView$ = PublishSubject<BappyLoginViewModel?>()
    private let showDeleteAccountView$ = PublishSubject<DeleteAccountViewModel?>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            notificationViewModel: ProfileSettingNotificationViewModel(),
            serviceViewModel: ProfileSettingServiceViewModel()
        )
        
        // MARK: Streams
        let showServiceView = serviceButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let switchToSignInView = switchToSignInView$
            .asSignal(onErrorJustReturn: nil)
        let showDeleteAccountView = showDeleteAccountView$
            .asSignal(onErrorJustReturn: nil)
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            serviceButtonTapped: serviceButtonTapped$.asObserver(),
            logoutButtonTapped: logoutButtonTapped$.asObserver(),
            deleteAccountButtonTapped: deleteAccountButtonTapped$.asObserver()
        )
        
        self.output = Output(
            showServiceView: showServiceView,
            switchToSignInView: switchToSignInView,
            showDeleteAccountView: showDeleteAccountView,
            popView: popView
        )
        
        // MARK: Bindind
        // 로그아웃 Flow
        let signOutResult = logoutButtonTapped$
            .flatMap(dependency.firebaseRepository.signOut)
            .share()
        
        signOutResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        signOutResult
            .compactMap(getValue)
            .map { _ in BappyLoginViewModel() }
            .bind(to: switchToSignInView$)
            .disposed(by: disposeBag)
        
        // 회원탈퇴뷰 탈퇴사유 리스트 FirebaseRemoteConfig로 불러오기
        let remoteConfigValuesResult = deleteAccountButtonTapped$
            .withLatestFrom(dependency.firebaseRepository.getRemoteConfigValues())
            .share()
        
        remoteConfigValuesResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        remoteConfigValuesResult
            .compactMap(getValue)
            .map(\.reasonsForWithdrawl)
            .map { reasons -> DeleteAccountViewModel? in
                let dependency = DeleteAccountViewModel.Dependency(
                    dropdownList: reasons)
                return DeleteAccountViewModel(dependency: dependency)
            }
            .bind(to: showDeleteAccountView$)
            .disposed(by: disposeBag)
        
        // Child(Service)
        subViewModels.serviceViewModel.output.serviceButtonTapped
            .emit(to: serviceButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.serviceViewModel.output.logoutButtonTapped
            .emit(to: logoutButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.serviceViewModel.output.deleteAccountButtonTapped
            .emit(to: deleteAccountButtonTapped$)
            .disposed(by: disposeBag)
    }
}
