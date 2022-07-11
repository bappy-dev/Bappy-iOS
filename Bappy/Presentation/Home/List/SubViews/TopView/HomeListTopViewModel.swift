//
//  HomeListTopViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeListTopViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {
        var localeButtonTapped: AnyObserver<Void> // <-> View
        var searchButtonTapped: AnyObserver<Void> // <-> View
        var filterButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var localeButtonTapped: Signal<Void> // <-> Parent
        var searchButtonTapped: Signal<Void> // <-> Parent
        var filterButtonTapped: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let localeButtonTapped$ = PublishSubject<Void>()
    private let searchButtonTapped$ = PublishSubject<Void>()
    private let filterButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let localeButtonTapped = localeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let searchButtonTapped = searchButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let filterButtonTapped = filterButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        // Input & Output
        self.input = Input(
            localeButtonTapped: localeButtonTapped$.asObserver(),
            searchButtonTapped: searchButtonTapped$.asObserver(),
            filterButtonTapped: filterButtonTapped$.asObserver()
        )
        
        self.output = Output(
            localeButtonTapped: localeButtonTapped,
            searchButtonTapped: searchButtonTapped,
            filterButtonTapped: filterButtonTapped
        )
        
        // Bindind

    }
}
