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
        var maxLength: Int { 500 }
    }
    
    struct Input {
        var reportingType: AnyObserver<String> // <-> Parent
        var editingDidBegin: AnyObserver<Void> // <-> View
        var detailText: AnyObserver<String> // <-> View
    }
    
    struct Output {
        var reportingType: Signal<String?> // <-> View
        var shouldHidePlaceholder: Driver<Bool> // <-> View
        var openDropdownView: Signal<Void> // <-> Parent
        var reportingDetail: Signal<String?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let reportingType$ = PublishSubject<String>()
    private let editingDidBegin$ = PublishSubject<Void>()
    private let detailText$ = PublishSubject<String>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let reportingType = reportingType$
            .map(String?.init)
            .asSignal(onErrorJustReturn: nil)
        let shouldHidePlaceholder = detailText$
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: true)
        let openDropdownView = editingDidBegin$
            .asSignal(onErrorJustReturn: Void())
        let reportingDetail = detailText$
            .map(String?.init)
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            reportingType: reportingType$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            detailText: detailText$.asObserver()
        )
        
        self.output = Output(
            reportingType: reportingType,
            shouldHidePlaceholder: shouldHidePlaceholder,
            openDropdownView: openDropdownView,
            reportingDetail: reportingDetail
        )
        
        // MARK: Bindind
    }
}
