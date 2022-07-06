//
//  ProfileLanguageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/05.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileLanguageViewModelDelegate: AnyObject {
    func selectedLanguages(_ languages: [Language])
}

final class ProfileLanguageViewModel: ViewModelType {
    
    weak var delegate: ProfileLanguageViewModelDelegate?
    
    struct Dependency {
        var userLanguages: [Language]
    }
    
    struct SubViewModels {
        let settingViewModel: LanguageSettingViewModel
    }
    
    struct Input {
        var closeButtonTapped: AnyObserver<Void> // <-> Child(Setting)
        var selectedLanguages: AnyObserver<[Language]> // <-> Child(Setting)
    }
    
    struct Output {
        var dismissView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let userLanguages$: BehaviorSubject<[Language]>
    
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let selectedLanguages$ = PublishSubject<[Language]>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            settingViewModel: LanguageSettingViewModel(
                dependency: .init(userLanguages: dependency.userLanguages)
            )
        )
        
        // Streams
        let userLanguages$ = BehaviorSubject<[Language]>(value: dependency.userLanguages)

        let dismissView = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            closeButtonTapped: closeButtonTapped$.asObserver(),
            selectedLanguages: selectedLanguages$.asObserver()
        )
        
        self.output = Output(
            dismissView: dismissView
        )
        
        // Bindind
        self.userLanguages$ = userLanguages$
        
        selectedLanguages$
            .bind(onNext: { [weak self] languages in
                self?.delegate?.selectedLanguages(languages)
            })
            .disposed(by: disposeBag)
        
        // Child(Setting)
        subViewModels.settingViewModel.output.closeButtonTapped
            .emit(to: closeButtonTapped$)
            .disposed(by: disposeBag)
        
        subViewModels.settingViewModel.output.selectedLanguages
            .skip(1)
            .emit(to: selectedLanguages$)
            .disposed(by: disposeBag)  
    }
}
