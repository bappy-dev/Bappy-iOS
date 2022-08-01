//
//  ReportWritingSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportWritingSectionViewModel: ViewModelType {
    
    struct Dependency {
        var dropdownList: [String]
        var maxLength: Int { 500 }
    }
    
    struct SubViewModels {
        let dropdownViewModel: BappyDropdownViewModel
    }
    
    struct Input {
        var editingDidBegin: AnyObserver<Void> // <-> View
        var detailText: AnyObserver<String> // <-> View
    }
    
    struct Output {
        var openDropdown: Signal<Void> // <-> View
        var closeDropdown: Signal<Void> // <-> View
        var dropdownText: Signal<String?> // <-> View
        var shouldHidePlaceholder: Driver<Bool> // <-> View
        var isReasonSelected: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let selectedText$ = PublishSubject<String?>()
    
    private let editingDidBegin$ = PublishSubject<Void>()
    private let detailText$ = PublishSubject<String>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            dropdownViewModel: BappyDropdownViewModel(
                dependency: .init(dropdownList: dependency.dropdownList)
            )
        )
        
        // MARK: Streams
        let openDropdown = editingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let closeDropdown = selectedText$
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        let dropdownText = selectedText$
            .asSignal(onErrorJustReturn: nil)
        let shouldHidePlaceholder = detailText$
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .startWith(false)
        let isReasonSelected = selectedText$
            .map { $0 != nil }
            .asSignal(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            editingDidBegin: editingDidBegin$.asObserver(),
            detailText: detailText$.asObserver()
        )
        
        self.output = Output(
            openDropdown: openDropdown,
            closeDropdown: closeDropdown,
            dropdownText: dropdownText,
            shouldHidePlaceholder: shouldHidePlaceholder,
            isReasonSelected: isReasonSelected
        )
        
        // MARK: Bindind
        subViewModels.dropdownViewModel.output.selectedText
            .emit(to: selectedText$)
            .disposed(by: disposeBag)
    }
}
