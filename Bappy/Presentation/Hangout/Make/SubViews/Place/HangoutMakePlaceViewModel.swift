//
//  HangoutMakePlaceViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakePlaceViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var editingDidBegin: AnyObserver<Void> // <-> View
        var map: AnyObserver<Map> // <-> Parent
    }
    
    struct Output {
        var endEditing: Signal<Void> // <-> View
        var text: Signal<String> // <-> View
        var showSearchPlaceView: Signal<Void> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let editingDidBegin$ = PublishSubject<Void>()
    private let map$ = PublishSubject<Map>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let endEditing = editingDidBegin$
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        let text = map$
            .map { "\($0.name)(\($0.address))" }
            .asSignal(onErrorJustReturn: "")
        let showSearchPlaceView = endEditing.skip(1)
        let isValid = map$
            .map { _ in true }
            .asSignal(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            editingDidBegin: editingDidBegin$.asObserver(),
            map: map$.asObserver()
        )
        
        self.output = Output(
            endEditing: endEditing,
            text: text,
            showSearchPlaceView: showSearchPlaceView,
            isValid: isValid
        )
    }
}
