//
//  HangoutMakePictureViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakePictureViewModel: ViewModelType {
    struct Dependency {}
    
    struct Input {
        var pictureButtonTapped: AnyObserver<Void> // <-> View
        var picture: AnyObserver<UIImage?> // <-> Parent
    }
    
    struct Output {
        var picture: Signal<UIImage?> // <-> View
        var hideDefaultImage: Signal<Bool> // <-> View
        var pictureButtonTapped: Signal<Void> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let pictureButtonTapped$ = PublishSubject<Void>()
    private let picture$ = PublishSubject<UIImage?>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // Streams
        let picture = picture$
            .asSignal(onErrorJustReturn: nil)
        let hideDefaultImage = picture$
            .map { $0 != nil }
            .asSignal(onErrorJustReturn: false)
        let pictureButtonTapped = pictureButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let isValid = hideDefaultImage
        
        // Input & Output
        self.input = Input(
            pictureButtonTapped: pictureButtonTapped$.asObserver(),
            picture: picture$.asObserver()
        )
        
        self.output = Output(
            picture: picture,
            hideDefaultImage: hideDefaultImage,
            pictureButtonTapped: pictureButtonTapped,
            isValid: isValid
        )
    }
}
