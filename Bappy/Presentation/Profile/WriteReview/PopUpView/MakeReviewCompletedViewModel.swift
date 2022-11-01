//
//  MakeReviewCompletedViewModel.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/25.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

final class MakeReviewCompletedViewModel: ViewModelType {
    struct Dependency {
        let user: BappyUser
        
        init(user: BappyUser) {
            self.user = user
        }
    }
    
    struct Input {
        var okayButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var moveToProfileView: Signal<BappyTabBarViewModel?>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let okayButtonTapped$ = PublishSubject<Void>()
    
    private let moveToProfileView$ = PublishSubject<BappyTabBarViewModel?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let moveToEditProfileView = moveToProfileView$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            okayButtonTapped: okayButtonTapped$.asObserver()
        )
        
        self.output = Output(
            moveToProfileView: moveToEditProfileView
        )
        
        // MARK: Binding
        okayButtonTapped$
            .map { _  -> BappyTabBarViewModel in
                let tabBarDependency = BappyTabBarViewModel.Dependency(
                    selectedIndex: 1,
                    user: dependency.user)
                return BappyTabBarViewModel(dependency: tabBarDependency)
            }
            .bind(to: moveToProfileView$)
            .disposed(by: disposeBag)
    }
}
