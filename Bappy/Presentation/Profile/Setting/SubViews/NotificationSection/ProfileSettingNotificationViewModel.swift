//
//  ProfileSettingNotificationViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSettingNotificationViewModel: ViewModelType {
    
    struct Dependency {
        var notificationSetting: NotificationSetting
        let bappyAuthRepository: BappyAuthRepository
        let notificationRepository: NotificationRepository
        
        init(notificationSetting: NotificationSetting,
             bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared,
             notificationRepository: NotificationRepository = DefaultNotificationRepository.shared) {
            self.notificationSetting = notificationSetting
            self.bappyAuthRepository = bappyAuthRepository
            self.notificationRepository = notificationRepository
        }
    }
    
    struct Input {
        var notificationSwitchTapped: AnyObserver<Void> // <-> View
        var myHangoutSwitchTapped: AnyObserver<Void> // <-> View
        var newHangoutSwitchTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var notificationSwitchState: Driver<Bool> // <-> View
        var myHangoutSwitchState: Driver<Bool> // <-> View
        var newHangoutSwitchtate: Driver<Bool> // <-> View
        var showAuthorizationAlert: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let notificationSetting$: BehaviorSubject<NotificationSetting>
    private let authorization$: BehaviorSubject<UNAuthorizationStatus?>

    private let notificationSwitchTapped$ = PublishSubject<Void>()
    private let myHangoutSwitchTapped$ = PublishSubject<Void>()
    private let newHangoutSwitchTapped$ = PublishSubject<Void>()
    private let showAuthorizationAlert$ = PublishSubject<Void>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let notificationSetting$ = BehaviorSubject<NotificationSetting>(value: dependency.notificationSetting)
        let authorization$ = dependency.notificationRepository.authorization
        
        let notificationSwitchState = notificationSetting$
            .map { $0.newHangout && $0.myHangout }
            .withLatestFrom(authorization$) { $0 && $1?.rawValue == 2 }
            .asDriver(onErrorJustReturn: false)
        let myHangoutSwitchState = notificationSetting$
            .map(\.myHangout)
            .withLatestFrom(authorization$) { $0 && $1?.rawValue == 2 }
            .asDriver(onErrorJustReturn: false)
        let newHangoutSwitchtate = notificationSetting$
            .map(\.newHangout)
            .withLatestFrom(authorization$) { $0 && ($1 == .authorized) }
            .asDriver(onErrorJustReturn: false)
        let showAuthorizationAlert = showAuthorizationAlert$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            notificationSwitchTapped: notificationSwitchTapped$.asObserver(),
            myHangoutSwitchTapped: myHangoutSwitchTapped$.asObserver(),
            newHangoutSwitchTapped: newHangoutSwitchTapped$.asObserver()
        )
        
        self.output = Output(
            notificationSwitchState: notificationSwitchState,
            myHangoutSwitchState: myHangoutSwitchState,
            newHangoutSwitchtate: newHangoutSwitchtate,
            showAuthorizationAlert: showAuthorizationAlert
        )
        
        // MARK: Bindind
        self.notificationSetting$ = notificationSetting$
        self.authorization$ = authorization$
        
        let allSettingFlow = notificationSwitchTapped$
            .withLatestFrom(authorization$)
            .filter { $0 == .authorized }
            .withLatestFrom(notificationSetting$)
            .map { $0.myHangout && $0.newHangout }
            .map { (myHangout: !$0, newHangout: !$0) }
            .share()
        
        let mySettingFlow = myHangoutSwitchTapped$
            .withLatestFrom(authorization$)
            .filter { $0 == .authorized }
            .withLatestFrom(notificationSetting$)
            .map { (myHangout: !$0.myHangout, newHangout: $0.newHangout) }
            .share()
        
        let newSettingFlow = newHangoutSwitchTapped$
            .withLatestFrom(authorization$)
            .filter { $0 == .authorized }
            .withLatestFrom(notificationSetting$)
            .map { (myHangout: $0.myHangout, newHangout: !$0.newHangout) }
            .share()
        
        let allSettingResult = allSettingFlow
            .flatMap(dependency.bappyAuthRepository.updateNotificationSetting)
            .share()
        
        let mySettingResult = mySettingFlow
            .flatMap(dependency.bappyAuthRepository.updateNotificationSetting)
            .share()
        
        let newSettingResult = newSettingFlow
            .flatMap(dependency.bappyAuthRepository.updateNotificationSetting)
            .share()
        
        Observable
            .merge(allSettingResult, mySettingResult, newSettingResult)
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                allSettingResult
                    .compactMap(getValue)
                    .withLatestFrom(allSettingFlow),
                mySettingResult
                    .compactMap(getValue)
                    .withLatestFrom(mySettingFlow),
                newSettingResult
                    .compactMap(getValue)
                    .withLatestFrom(newSettingFlow)
            )
            .map(NotificationSetting.init)
            .bind(to: notificationSetting$)
            .disposed(by: disposeBag)
        
        authorization$
            .bind(onNext: {
                print("DEBUG: authorization \($0!.rawValue)")
            })
            .disposed(by: disposeBag)
        
        let switchWithAuthorization = Observable
            .merge(
                notificationSwitchTapped$,
                myHangoutSwitchTapped$,
                newHangoutSwitchTapped$
            )
            .withLatestFrom(authorization$)
            .share()
        
        // 권한 미설정시 권한 요청 띄우기
        let requestAuthorizationResult = switchWithAuthorization
            .filter { $0 == .notDetermined }
            .map { _ in }
            .flatMap(dependency.notificationRepository.requestAuthorization)
            .share()
        
        requestAuthorizationResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        // 권한 거부시 설정 Alert 표시
        switchWithAuthorization
            .filter { $0 == .denied }
            .map { _ in }
            .bind(to: showAuthorizationAlert$)
            .disposed(by: disposeBag)
        
        dependency.notificationRepository.requestAuthorization(completion: nil)
    }
}
