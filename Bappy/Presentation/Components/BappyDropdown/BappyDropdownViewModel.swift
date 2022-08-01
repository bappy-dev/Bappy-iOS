//
//  BappyDropdownViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class BappyDropdownViewModel: ViewModelType {
    
    struct Dependency {
        var dropdownList: [String]
    }
    
    struct Input {
        var itemSelected: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var dropdownList: Driver<[String]> // <-> View
        var selectedText: Signal<String?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let dropdownList$: BehaviorSubject<[String]>
    
    private let itemSelected$ = PublishSubject<IndexPath>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let dropdownList$ = BehaviorSubject<[String]>(value: dependency.dropdownList)
        
        let dropdownList = dropdownList$
            .asDriver(onErrorJustReturn: [])
        let selectedText = itemSelected$
            .withLatestFrom(dropdownList) { $1[$0.row] }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            itemSelected: itemSelected$.asObserver()
        )
        
        self.output = Output(
            dropdownList: dropdownList,
            selectedText: selectedText
        )
        
        // MARK: Bindind
        self.dropdownList$ = dropdownList$
            
    }
}
