//
//  RegisterNationalityViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterNationalityViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var country: AnyObserver<Country>
        var textFieldTapped: AnyObserver<Void>
    }
    
    struct Output {
        var country: Signal<String?>
        var isValid: Driver<Bool>
        var textFieldTapped: Signal<Void>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let country$ = PublishSubject<Country>()
    private let textFieldTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let country = country$
            .map { "\($0.name) \($0.flag)" }
            .asSignal(onErrorJustReturn: nil)
        let isValid = country
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        let textFieldTapped = textFieldTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            country: country$.asObserver(),
            textFieldTapped: textFieldTapped$.asObserver()
        )
        
        self.output = Output(
            country: country,
            isValid: isValid,
            textFieldTapped: textFieldTapped
        )
        
        // MARK: Binding

    }
}
