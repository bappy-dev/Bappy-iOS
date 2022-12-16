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
        var pictureURL: AnyObserver<URL?>
    }
    
    struct Output {
        var picture: Signal<UIImage?> // <-> View
        var hideDefaultImage: Signal<Bool> // <-> View
        var pictureButtonTapped: Signal<Void> // <-> Parent
        var isValid: Signal<Bool> // <-> Parent
        var pictureURL: Signal<URL?>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let pictureButtonTapped$ = PublishSubject<Void>()
    private let picture$ = PublishSubject<UIImage?>()
    private let pictureURL$ = BehaviorSubject<URL?>(value: nil)
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let picture = picture$
            .asSignal(onErrorJustReturn: nil)
        let hideDefaultImage = picture$
            .map { $0 != nil }
            .asSignal(onErrorJustReturn: false)
        let pictureButtonTapped = pictureButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let pictureURL = pictureURL$
            .asSignal(onErrorJustReturn: nil)
        let isValid = hideDefaultImage
        
        // MARK: Input & Output
        self.input = Input(
            pictureButtonTapped: pictureButtonTapped$.asObserver(),
            picture: picture$.asObserver(),
            pictureURL: pictureURL$.asObserver()
        )
        
        self.output = Output(
            picture: picture,
            hideDefaultImage: hideDefaultImage,
            pictureButtonTapped: pictureButtonTapped,
            isValid: isValid,
            pictureURL: pictureURL
        )
    }
}
