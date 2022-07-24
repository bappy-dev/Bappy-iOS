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
        var showLoginView: Signal<Void> // <-> View
        var showDeleteAccountView: Signal<Void> // <-> View
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
  
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            notificationViewModel: ProfileSettingNotificationViewModel(),
            serviceViewModel: ProfileSettingServiceViewModel()
        )
        
        // Streams
        let showServiceView = serviceButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showLoginView = logoutButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showDeleteAccountView = deleteAccountButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            serviceButtonTapped: serviceButtonTapped$.asObserver(),
            logoutButtonTapped: logoutButtonTapped$.asObserver(),
            deleteAccountButtonTapped: deleteAccountButtonTapped$.asObserver()
        )
        
        self.output = Output(
            showServiceView: showServiceView,
            showLoginView: showLoginView,
            showDeleteAccountView: showDeleteAccountView,
            popView: popView
        )
        
        // Bindind
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
