//
//  ProfileDetailAffiliationViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/03.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailAffiliationViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var affiliation: String { "No Contents" }
    }
    
    struct Input {}
    
    struct Output {
        var affiliation: Driver<String> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let affiliation = user$
            .map { $0.affiliation ?? "" }
            .map { $0.isEmpty ? dependency.affiliation : $0 }
            .asDriver(onErrorJustReturn: dependency.affiliation)
        
        // Input & Output
        self.input = Input(
        )
        
        self.output = Output(
            affiliation: affiliation
        )
        
        // Bindind
        self.user$ = user$
    }
}
