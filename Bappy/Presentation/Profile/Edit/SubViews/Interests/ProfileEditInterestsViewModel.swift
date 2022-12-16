//
//  ProfileEditInterestsViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditInterestsViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
    }
    
    struct SubViewModels {
        let categoryViewModel: CategoryViewModel
    }
    
    struct Input { }
    
    struct Output {
        var edittedInterests: Signal<[Hangout.Category]> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(categoryViewModel: CategoryViewModel(dependency: CategoryViewModel.Dependency(categories: dependency.user.interests ?? [], isSmall: true)))
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            edittedInterests: subViewModels.categoryViewModel.output.categories
        )
    }
}
