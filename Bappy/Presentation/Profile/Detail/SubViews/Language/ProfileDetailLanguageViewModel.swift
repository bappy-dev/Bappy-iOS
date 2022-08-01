//
//  ProfileDetailLanguageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/03.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailLanguageViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var languages: String { "No Contents" }
    }
    
    struct Input {}
    
    struct Output {
        var languages: Driver<String> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let languages = user$
            .map { $0.languages?.joined(separator: " / ") ?? dependency.languages }
            .asDriver(onErrorJustReturn: dependency.languages)
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            languages: languages
        )
        
        // MARK: Bindind
        self.user$ = user$
    }
}
