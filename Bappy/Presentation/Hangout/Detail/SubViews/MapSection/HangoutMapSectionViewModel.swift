//
//  HangoutMapSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMapSectionViewModel: ViewModelType {
    
    struct Dependency {
        var hangout: Hangout
        var mapImage: UIImage?
        var isPreviewModel: Bool { hangout.state == .preview }
        var placeName: String { hangout.place.name }
    }
    
    struct Input {
        var mapButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var mapButtonTapped: Signal<Void> // <-> Parent
        var placeName: Driver<String> // <-> View
        var mapImage: Signal<UIImage?> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let isPreviewModel$: BehaviorSubject<Bool>
    private let placeName$: BehaviorSubject<String>
    private let mapImage$: BehaviorSubject<UIImage?>
    
    private let mapButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let isPreviewModel$ = BehaviorSubject<Bool>(value: dependency.isPreviewModel)
        let placeName$ = BehaviorSubject<String>(value: dependency.placeName)
        let mapImage$ = BehaviorSubject<UIImage?>(value: dependency.mapImage)
        
        let mapButtonTapped = mapButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let placeName = placeName$
            .asDriver(onErrorJustReturn: dependency.placeName)
        let mapImage = isPreviewModel$
            .filter { $0 }
            .withLatestFrom(mapImage$)
            .asSignal(onErrorJustReturn: dependency.mapImage)
        
        // MARK: Input & Output
        self.input = Input(
            mapButtonTapped: mapButtonTapped$.asObserver()
        )
        
        self.output = Output(
            mapButtonTapped: mapButtonTapped,
            placeName: placeName,
            mapImage: mapImage
        )
        
        // MARK: Bindind
        self.isPreviewModel$ = isPreviewModel$
        self.placeName$ = placeName$
        self.mapImage$ = mapImage$
    }
}
