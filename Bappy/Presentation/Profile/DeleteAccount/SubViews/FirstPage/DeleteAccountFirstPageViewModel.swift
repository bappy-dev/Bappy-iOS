//
//  DeleteAccountFirstPageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa

final class DeleteAccountFirstPageViewModel: ViewModelType {
    
    struct SubViewModels {

    }
    
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
    let subViewModels: SubViewModels
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels()
        
        // MARK: Streams
        
        // MARK: Input & Output
        self.input = Input(
        )
        
        self.output = Output(
        )
        
        // MARK: Bindind
            
    }
}
