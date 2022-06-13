//
//  RegisterGenderViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterGenderViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var maleButtonTapped: AnyObserver<Void>
        var femaleButtonTapped: AnyObserver<Void>
        var otherButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var gender: Signal<Gender>
        var isMaleSelected: Driver<Bool>
        var isFemaleSelected: Driver<Bool>
        var isOtherSelected: Driver<Bool>
        var isValid: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let gender$ = PublishSubject<Gender>()
    private let maleButtonTapped$ = PublishSubject<Void>()
    private let femaleButtonTapped$ = PublishSubject<Void>()
    private let otherButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let gender = gender$
            .asSignal(onErrorJustReturn: .other)
        let isMaleSelected = gender
            .map { $0 == .male }
            .asDriver(onErrorJustReturn: false)
        let isFemaleSelected = gender
            .map { $0 == .female }
            .asDriver(onErrorJustReturn: false)
        let isOtherSelected = gender
            .map { $0 == .other }
            .asDriver(onErrorJustReturn: false)
        let isValid = gender
            .map { _ in true }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            maleButtonTapped: maleButtonTapped$.asObserver(),
            femaleButtonTapped: femaleButtonTapped$.asObserver(),
            otherButtonTapped: otherButtonTapped$.asObserver()
        )
        
        self.output = Output(
            gender: gender,
            isMaleSelected: isMaleSelected,
            isFemaleSelected: isFemaleSelected,
            isOtherSelected: isOtherSelected,
            isValid: isValid
        )
        
        // Binding
        maleButtonTapped$
            .map { Gender.male }
            .bind(to: gender$)
            .disposed(by: disposeBag)
        
        femaleButtonTapped$
            .map { Gender.female }
            .bind(to: gender$)
            .disposed(by: disposeBag)
        
        otherButtonTapped$
            .map { Gender.other }
            .bind(to: gender$)
            .disposed(by: disposeBag)
    }
}
