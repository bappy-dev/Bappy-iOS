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
    struct Dependency {
        var gender: Gender
    }
    
    struct Input {
        var maleButtonTapped: AnyObserver<Void>
        var femaleButtonTapped: AnyObserver<Void>
        var otherButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var gender: Signal<Gender>
        var isMaleSelected: BehaviorRelay<Bool>
        var isFemaleSelected: BehaviorRelay<Bool>
        var isOtherSelected: BehaviorRelay<Bool>
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
    
    init(dependency: Dependency = Dependency(gender: .other)) {
        self.dependency = dependency
        
        // Streams
        let gender = gender$
            .asSignal(onErrorJustReturn: dependency.gender)
        let isMaleSelected = BehaviorRelay<Bool>(value: false)
        let isFemaleSelected = BehaviorRelay<Bool>(value: false)
        let isOtherSelected = BehaviorRelay<Bool>(value: false)
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
        
        gender
            .map { $0 == .male }
            .emit(to: isMaleSelected)
            .disposed(by: disposeBag)
        
        gender
            .map { $0 == .female }
            .emit(to: isFemaleSelected)
            .disposed(by: disposeBag)
        
        gender
            .map { $0 == .other }
            .emit(to: isOtherSelected)
            .disposed(by: disposeBag)
    }
}
