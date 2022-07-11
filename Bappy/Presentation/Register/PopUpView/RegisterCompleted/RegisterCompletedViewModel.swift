//
//  RegisterCompletedViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterCompletedViewModel: ViewModelType {
    struct Dependency {
        let user: BappyUser
        let bappyAuthRepository: BappyAuthRepository
    }
    
    struct Input {
        var okayButtonTapped: AnyObserver<Void>
        var laterButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var switchToMainView: PublishSubject<BappyTabBarViewModel>
        var moveToEditProfileView: PublishSubject<BappyTabBarViewModel>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let okayButtonTapped$ = PublishSubject<Void>()
    private let laterButtonTapped$ = PublishSubject<Void>()
    
    private let switchToMainView$ = PublishSubject<BappyTabBarViewModel>()
    private let moveToEditProfileView$ = PublishSubject<BappyTabBarViewModel>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        
        // Input & Output
        self.input = Input(
            okayButtonTapped: okayButtonTapped$.asObserver(),
            laterButtonTapped: laterButtonTapped$.asObserver()
        )
        
        self.output = Output(
            switchToMainView: switchToMainView$,
            moveToEditProfileView: moveToEditProfileView$
        )
        
        // Binding
        laterButtonTapped$
            .map { _  -> BappyTabBarViewModel in
                let dependency = BappyTabBarViewModel.Dependency(
                    selectedIndex: 0,
                    user: dependency.user,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return BappyTabBarViewModel(dependency: dependency)
            }
            .bind(to: switchToMainView$)
            .disposed(by: disposeBag)
        
        okayButtonTapped$
            .map { _  -> BappyTabBarViewModel in
                let dependency = BappyTabBarViewModel.Dependency(
                    selectedIndex: 1,
                    user: dependency.user,
                    bappyAuthRepository: dependency.bappyAuthRepository)
                return BappyTabBarViewModel(dependency: dependency)
            }
            .bind(to: switchToMainView$)
            .disposed(by: disposeBag)
    }
}
