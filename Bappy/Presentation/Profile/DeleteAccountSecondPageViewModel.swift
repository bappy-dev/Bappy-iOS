//
//  DeleteAccountSecondPageViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa

final class DeleteAccountSecondPageViewModel: ViewModelType {
    
    struct Dependency {
        var dropdownList: [String] {
            [
                "There is no hangout I want to join.",
                "I am looking for dates.",
                "Hangouts are far from my area.",
                "It is a bothersome to make hangout.",
                "This app is hard to use.",
                "So many perverts or weirdos.",
                "I had a bad experience in hangout.",
                "I don’t use this app a lot.",
                "I want to make a new account.",
                "Something else"
            ]
        }
    }
    
    struct SubViewModels {
        let dropdownViewModel: BappyDropdownViewModel
    }
    
    struct Input {
        var editingDidBegin: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var openDropdown: Signal<Void> // <-> View
        var closeDropdown: Signal<Void> // <-> View
        var text: Signal<String?> // <-> View
        var isReasonSelected: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let editingDidBegin$ = PublishSubject<Void>()
    private let selectedText$ = PublishSubject<String?>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            dropdownViewModel: BappyDropdownViewModel(
                dependency: .init(dropdownList: dependency.dropdownList)
            )
        )
            
        
        // Streams
        let openDropdown = editingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let closeDropdown = selectedText$
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        let text = selectedText$
            .asSignal(onErrorJustReturn: nil)
        let isReasonSelected = selectedText$
            .map { $0 != nil }
            .asSignal(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(
            editingDidBegin: editingDidBegin$.asObserver()
        )
        
        self.output = Output(
            openDropdown: openDropdown,
            closeDropdown: closeDropdown,
            text: text,
            isReasonSelected: isReasonSelected
        )
        
        // Bindind
        subViewModels.dropdownViewModel.output.selectedText
            .emit(to: selectedText$)
            .disposed(by: disposeBag)
    }
}
