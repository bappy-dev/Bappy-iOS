//
//  LocaleSearchViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/12.
//

import UIKit
import RxSwift
import RxCocoa

final class LocaleSearchViewModel: ViewModelType {
    
    struct Dependency {
        let googleMapRepository: GoogleMapsRepository
    }
    
    struct Input {}
    
    struct Output {}
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    init(dependency: Dependency = .init(googleMapRepository: DefaultGoogleMapsRepository())) {
        self.dependency = dependency
        
        // Streams
        
        // Input & Output
        self.input = Input()
        
        self.output = Output()
        
        // Bindind

    }
}
