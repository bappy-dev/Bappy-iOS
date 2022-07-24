//
//  ReportImageSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportImageSectionViewModel: ViewModelType {
    
    struct Dependency {
        var maxNumOfImages: Int
    }
    
    struct Input {
        var selectedImages: AnyObserver<[UIImage]> // <-> Parent
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var removePhoto: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var selectedImages: Driver<[UIImage?]> // <-> View
        var numOfImages: Driver<String?> // <-> View
        var addPhoto: Signal<Void> // <-> Parent
        var removePhoto: Signal<Int?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let maxNumOfImages$: BehaviorSubject<Int>
    
    private let selectedImages$ = BehaviorSubject<[UIImage]>(value: [])
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let removePhoto$ = PublishSubject<IndexPath>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let maxNumOfImages$ = BehaviorSubject<Int>(value: dependency.maxNumOfImages)
        
        let selectedImages = selectedImages$
            .map { [nil] + $0 }
            .asDriver(onErrorJustReturn: [nil])
        let numOfImages = Observable
            .combineLatest(selectedImages$, maxNumOfImages$)
            .map { "\($0.0.count)/\($0.1)" }
            .asDriver(onErrorJustReturn: nil)
        let addPhoto = itemSelected$
            .filter { $0.item == 0 }
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        let removePhoto = removePhoto$
            .map { $0.item - 1 }
            .asSignal(onErrorJustReturn: nil)
        
        // Input & Output
        self.input = Input(
            selectedImages: selectedImages$.asObserver(),
            itemSelected: itemSelected$.asObserver(),
            removePhoto: removePhoto$.asObserver()
        )
        
        self.output = Output(
            selectedImages: selectedImages,
            numOfImages: numOfImages,
            addPhoto: addPhoto,
            removePhoto: removePhoto
        )
        
        // Bindind
        self.maxNumOfImages$ = maxNumOfImages$
    }
}
