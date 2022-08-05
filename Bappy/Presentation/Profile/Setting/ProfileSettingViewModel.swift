//
//  ProfileSettingViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/02.
//

import UIKit
import RxSwift
import RxCocoa
import CoreMIDI

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
    
    private let reasonsForWithdrawl$ = BehaviorSubject<[String]?>(value: nil)
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let serviceButtonTapped$ = PublishSubject<Void>()
    private let logoutButtonTapped$ = PublishSubject<Void>()
    private let deleteAccountButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            notificationViewModel: ProfileSettingNotificationViewModel(),
            serviceViewModel: ProfileSettingServiceViewModel()
        )
        
        // MARK: Streams
        let showServiceView = serviceButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let switchToSignInView = logoutButtonTapped$
            .map { _ -> BappyLoginViewModel in
                let dependency = BappyLoginViewModel.Dependency(
                    bappyAuthRepository: dependency.bappyAuthRepository,
                    firebaseRepository: dependency.firebaseRepository)
                return BappyLoginViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let showDeleteAccountView = deleteAccountButtonTapped$
            .withLatestFrom(reasonsForWithdrawl$)
            .compactMap { reasons -> DeleteAccountViewModel? in
                guard let reasons = reasons else { return nil }
                let dependency = DeleteAccountViewModel.Dependency(
                    dropdownList: reasons)
                return DeleteAccountViewModel(dependency: dependency)
            }
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
        let remoteConfigValuesResult = dependency.firebaseRepository.getRemoteConfigValues()
            .share()
        
        remoteConfigValuesResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        remoteConfigValuesResult
            .compactMap(getValue)
            .map(\.reasonsForWithdrawl)
            .bind(to: reasonsForWithdrawl$)
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
