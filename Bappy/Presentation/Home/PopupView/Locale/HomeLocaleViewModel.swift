//
//  HomeLocaleViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeLocaleViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let locationRepsitory: LocationRepository
    }
    
    struct SubViewModels {
        let settingViewModel: LocaleSettingViewModel
    }
    
    struct Input {
        var closeButtonTapped: AnyObserver<Void> // <-> Child
        var showAuthorizationAlert: AnyObserver<Void> // <-> Child
    }
    
    struct Output {
        var dismissView: Signal<Void> // <-> View
        var showAuthorizationAlert: Signal<Alert?> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let closeButtonTapped$ = PublishSubject<Void>()
    
    private let showAuthorizationAlert$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            settingViewModel: LocaleSettingViewModel(dependency: .init(
                bappyAuthRepository: dependency.bappyAuthRepository,
                locationRepsitory: dependency.locationRepsitory))
        )
        
        // Streams
        let dismissView = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showAuthorizationAlert = showAuthorizationAlert$
            .map { _ -> Alert in
                let title = "Permission Denied"
                let message = "Please Turn On Location Service\nto Allow \"Bappy\"\nto Determine Your Location"
                let actionTitle = "Setting"
                
                let action = Alert.Action(
                    actionTitle: actionTitle,
                    actionStyle: .disclosure) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                
                return Alert(
                    title: title,
                    message: message,
                    bappyStyle: .happy,
                    canCancel: true,
                    action: action
                    )
            }
            .asSignal(onErrorJustReturn: nil)
        
        // Input & Output
        self.input = Input(
            closeButtonTapped: closeButtonTapped$.asObserver(),
            showAuthorizationAlert: showAuthorizationAlert$.asObserver()
        )
        
        self.output = Output(
            dismissView: dismissView,
            showAuthorizationAlert: showAuthorizationAlert
        )
        
        // Bindind
        
        // Child
        subViewModels.settingViewModel.output.closeButtonTapped
            .emit(to: closeButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.settingViewModel.output.showAuthorizationAlert
            .emit(to: showAuthorizationAlert$)
            .disposed(by: disposeBag)
    }
}
