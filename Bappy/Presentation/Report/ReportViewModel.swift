//
//  ReportViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportViewModel: ViewModelType {
    
    struct Dependency {
        var maxNumOfImages: Int { 5 }
    }
    
    struct SubViewModels {
        let writingViewModel: ReportWritingSectionViewModel
        let imageViewModel: ReportImageSectionViewModel
    }
    
    struct Input {
        var backButtonTapped: AnyObserver<Void> // <-> View
        var reportButtonTapped: AnyObserver<Void> // <-> View
        var addedImage: AnyObserver<UIImage> // <-> View
        var addPhoto: AnyObserver<Void> // <-> Child(Image)
        var removePhoto: AnyObserver<Int> // <-> Child(Image)
    }
    
    struct Output {
        var popView: Signal<Void> // <-> View
        var showPHPickerView: Signal<Int?> // <-> View
        var selectedImages: Signal<[UIImage]> // <-> Child(Image)
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let maxNumOfImages$: BehaviorSubject<Int>
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let reportButtonTapped$ = PublishSubject<Void>()
    private let addedImage$ = PublishSubject<UIImage>()
    private let addPhoto$ = PublishSubject<Void>()
    private let removePhoto$ = PublishSubject<Int>()
    
    private let selectedImages$ = BehaviorSubject<[UIImage]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            writingViewModel: ReportWritingSectionViewModel(dependency: .init()),
            imageViewModel: ReportImageSectionViewModel(dependency: .init(maxNumOfImages: dependency.maxNumOfImages))
        )
        
        // Streams
        let maxNumOfImages$ = BehaviorSubject<Int>(value: dependency.maxNumOfImages)
        
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showPHPickerView = addPhoto$
            .withLatestFrom(maxNumOfImages$)
            .withLatestFrom(selectedImages$) { $0 - $1.count }
            .asSignal(onErrorJustReturn: nil)
        let selectedImages = selectedImages$
            .asSignal(onErrorJustReturn: [])
          
        // Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            reportButtonTapped: reportButtonTapped$.asObserver(),
            addedImage: addedImage$.asObserver(),
            addPhoto: addPhoto$.asObserver(),
            removePhoto: removePhoto$.asObserver()
        )
        
        self.output = Output(
            popView: popView,
            showPHPickerView: showPHPickerView,
            selectedImages: selectedImages
        )
        
        // Bindind
        self.maxNumOfImages$ = maxNumOfImages$
        
        addedImage$
            .withLatestFrom(selectedImages$) { $1 + [$0] }
            .bind(to: selectedImages$)
            .disposed(by: disposeBag)
        
        removePhoto$
            .withLatestFrom(selectedImages$) { row, images in
                var images = images
                images.remove(at: row)
                return images
            }
            .bind(to: selectedImages$)
            .disposed(by: disposeBag)
        
        // Child(Image)
        selectedImages
            .emit(to:subViewModels.imageViewModel.input.selectedImages)
            .disposed(by: disposeBag)
            
        subViewModels.imageViewModel.output.addPhoto
            .emit(to: addPhoto$)
            .disposed(by: disposeBag)
        
        subViewModels.imageViewModel.output.removePhoto
            .compactMap { $0 }
            .emit(to: removePhoto$)
            .disposed(by: disposeBag)
    }
}
