//
//  ProfileDetailIntroduceViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/03.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailIntroduceViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var introduce: String { "No Contents" }
    }
    
    struct Input {}
    
    struct Output {
        var introduce: Driver<String> // <-> View
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
        
        let introduce = user$
            .map { $0.introduce ?? "" }
            .map { $0.isEmpty ? dependency.introduce : $0 }
            .asDriver(onErrorJustReturn: dependency.introduce)
        
        // Input & Output
        self.input = Input()
        
        self.output = Output(
            introduce: introduce
        )
        
        // Bindind
        self.user$ = user$
    }
}
