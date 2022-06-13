//
//  RegisterNationalityViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterNationalityViewModel: ViewModelType {
    struct Dependency {
      
    }
    
    struct Input {
   
    }
    
    struct Output {
      
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        
        // Input & Output
        self.input = Input()
        self.output = Output()
        
        // Binding

    }
}
