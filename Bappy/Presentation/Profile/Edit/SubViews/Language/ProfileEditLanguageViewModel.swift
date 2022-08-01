//
//  ProfileEditLanguageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditLanguageViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var languages: String { "No Contents" }
    }
    
    struct Input {
        var text: AnyObserver<String> // <-> View
        var didBeginEditing: AnyObserver<Void> // <-> View
        var selectedLanguages: AnyObserver<[Language]?> // <-> Parent
    }
    
    struct Output {
        var placeHolder: Driver<String> // <-> View
        var shouldHidePlaceHolder: Driver<Bool> // <-> View
        var text: Signal<String?> // <-> View
        var didBeginEditing: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
    
    private let text$ = BehaviorSubject<String>(value: "")
    private let didBeginEditing$ = PublishSubject<Void>()
    private let selectedLanguages$ = PublishSubject<[Language]?>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let placeHolder = user$
            .map { $0.languages?.joined(separator: " / ") ?? dependency.languages }
            .asDriver(onErrorJustReturn: dependency.languages)
        let shouldHidePlaceHolder = text$
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        let text = selectedLanguages$
            .map { $0?.joined(separator: " / ") }
            .asSignal(onErrorJustReturn: nil)
        let didBeginEditing = didBeginEditing$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            text: text$.asObserver(),
            didBeginEditing: didBeginEditing$.asObserver(),
            selectedLanguages: selectedLanguages$.asObserver()
        )
        
        self.output = Output(
            placeHolder: placeHolder,
            shouldHidePlaceHolder: shouldHidePlaceHolder,
            text: text,
            didBeginEditing: didBeginEditing
        )
        
        // MARK: Bindind
        self.user$ = user$
    }
}
