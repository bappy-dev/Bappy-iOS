//
//  ProfileSettingViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/02.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSettingViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
    }
    
    struct Input {

    }
    
    struct Output {

    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        
        // Input & Output
        self.input = Input(
        )
        
        self.output = Output(
        )
        
        // Bindind
    }
}
