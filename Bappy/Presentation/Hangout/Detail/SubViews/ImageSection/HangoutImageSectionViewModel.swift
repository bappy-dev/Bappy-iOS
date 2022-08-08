//
//  HangoutImageSectionViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutImageSectionViewModel: ViewModelType {
    
    struct Dependency {
        var hangout: Hangout
        var postImage: UIImage?
    }
    
    struct Input {
        var hangout: AnyObserver<Hangout> // <-> Parent
        var imageHeight: AnyObserver<CGFloat> // <-> Parent
        var likeButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var imageURL: Signal<URL?> // <-> View
        var image: Signal<UIImage?> // <-> View
        var userHasLiked: Driver<Bool> // <-> View
        var imageHeight: Signal<CGFloat> // <-> View
        var likeButtonTapped: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let hangout$: BehaviorSubject<Hangout>
    private let postImage$: BehaviorSubject<UIImage?>
    
    private let imageHeight$ = PublishSubject<CGFloat>()
    private let likeButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let hangout$ = BehaviorSubject<Hangout>(value: dependency.hangout)
        let postImage$ = BehaviorSubject<UIImage?>(value: dependency.postImage)
        
        let imageURL = hangout$
            .filter { $0.state != .preview }
            .map(\.postImageURL)
            .asSignal(onErrorJustReturn: nil)
        let image = hangout$
            .filter { $0.state == .preview }
            .withLatestFrom(postImage$)
            .asSignal(onErrorJustReturn: nil)
        let userHasLiked = hangout$
            .map(\.userHasLiked)
            .asDriver(onErrorJustReturn: false)
        let imageHeight = imageHeight$
            .asSignal(onErrorJustReturn: 0)
        let likeButtonTapped = likeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            hangout: hangout$.asObserver(),
            imageHeight: imageHeight$.asObserver(),
            likeButtonTapped: likeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            imageURL: imageURL,
            image: image,
            userHasLiked: userHasLiked,
            imageHeight: imageHeight,
            likeButtonTapped: likeButtonTapped
        )
        
        // MARK: Bindind
        self.hangout$ = hangout$
        self.postImage$ = postImage$
    }
}
