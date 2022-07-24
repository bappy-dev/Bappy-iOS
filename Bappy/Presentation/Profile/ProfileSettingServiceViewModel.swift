//
//  ProfileSettingServiceViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSettingServiceViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var serviceButtonTapped: AnyObserver<Void> // <-> View
        var logoutButtonTapped: AnyObserver<Void> // <-> View
        var deleteAccountButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var serviceButtonTapped: Signal<Void> // <-> Parent
        var logoutButtonTapped: Signal<Void> // <-> Parent
        var deleteAccountButtonTapped: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let serviceButtonTapped$ = PublishSubject<Void>()
    private let logoutButtonTapped$ = PublishSubject<Void>()
    private let deleteAccountButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let serviceButtonTapped = serviceButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let logoutButtonTapped = logoutButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let deleteAccountButtonTapped = deleteAccountButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            serviceButtonTapped: serviceButtonTapped$.asObserver(),
            logoutButtonTapped: logoutButtonTapped$.asObserver(),
            deleteAccountButtonTapped: deleteAccountButtonTapped$.asObserver()
        )
        
        self.output = Output(
            serviceButtonTapped: serviceButtonTapped,
            logoutButtonTapped: logoutButtonTapped,
            deleteAccountButtonTapped: deleteAccountButtonTapped
        )
        
        // Bindind
    }
}
