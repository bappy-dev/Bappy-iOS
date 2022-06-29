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
        let profile: Profile
        let currentUserRepository: CurrentUserRepository
    }
    
    struct Input {

    }
    
    struct Output {
        var hideSettingButton: Signal<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let profile$: BehaviorSubject<Profile>
    private let currentUser$: BehaviorSubject<BappyUser?>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let profile$ = BehaviorSubject<Profile>(value: dependency.profile)
        let currentUser$ = dependency.currentUserRepository.currentUser
        
        let hideSettingButton = Observable
            .combineLatest(profile$, currentUser$.compactMap { $0 })
            .map { $0.0.user != $0.1 }
            .startWith(true)
            .asSignal(onErrorJustReturn: true)
        
        // Input & Output
        self.input = Input(
        )
        
        self.output = Output(
            hideSettingButton: hideSettingButton
        )
        
        // Bindind
        self.profile$ = profile$
        self.currentUser$ = currentUser$
    }
}
