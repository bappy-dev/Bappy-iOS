//
//  HangoutMakeOpenchatViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeOpenchatViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {}
    
    struct Output {}
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        
        // Input & Output
        self.input = Input()
        self.output = Output()
        
        // Binding

    }
}
