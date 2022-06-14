//
//  RegisterCompletedViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterCompletedViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var okayButtonTapped: AnyObserver<Void>
        var laterButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var okayButtonTapped: Signal<Void>
        var laterButtonTapped: Signal<Void>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let okayButtonTapped$ = PublishSubject<Void>()
    private let laterButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let okayButtonTapped = okayButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let laterButtonTapped = laterButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            okayButtonTapped: okayButtonTapped$.asObserver(),
            laterButtonTapped: laterButtonTapped$.asObserver()
        )
        
        self.output = Output(
            okayButtonTapped: okayButtonTapped,
            laterButtonTapped: laterButtonTapped
        )
        
        // Binding

    }
}
