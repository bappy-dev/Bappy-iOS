//
//  HomeLocaleViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeLocaleViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
    }
    
    struct SubViewModels {
        let settingViewModel: LocaleSettingViewModel
    }
    
    struct Input {
        var closeButtonTapped: AnyObserver<Void> // <-> Child
    }
    
    struct Output {
        var dismissView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let closeButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            settingViewModel: LocaleSettingViewModel(dependency: .init(
                bappyAuthRepository: dependency.bappyAuthRepository))
        )
        
        // Streams
        let dismissView = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            closeButtonTapped: closeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            dismissView: dismissView
        )
        
        // Bindind
        
        // Child
        subViewModels.settingViewModel.output.closeButtonTapped
            .emit(to: closeButtonTapped$)
            .disposed(by: disposeBag)
    }
}
