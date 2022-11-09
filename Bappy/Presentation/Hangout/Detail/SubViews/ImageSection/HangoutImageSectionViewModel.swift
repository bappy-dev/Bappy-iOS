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
        var image: Signal<(URL?, UIImage?)> // <-> View
        var userHasLiked: Driver<Bool> // <-> View
        var imageHeight: Signal<CGFloat> // <-> View
        var likeButtonTapped: Signal<Void> // <-> Parent
        var likeButtonHidden: Signal<Bool>
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
        
        let image = hangout$
            .withLatestFrom(postImage$) { ($0, $1)}
            .map { ($0.0.postImageURL, $0.1) }
            .asSignal(onErrorJustReturn: (nil, nil))
        let userHasLiked = hangout$
            .map(\.userHasLiked)
            .asDriver(onErrorJustReturn: false)
        let imageHeight = imageHeight$
            .asSignal(onErrorJustReturn: 0)
        let likeButtonTapped = likeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let likeButtonHidden = hangout$
            .map(\.state)
            .map { $0 == .preview }
            .asSignal(onErrorJustReturn: true)
        
        // MARK: Input & Output
        self.input = Input(
            hangout: hangout$.asObserver(),
            imageHeight: imageHeight$.asObserver(),
            likeButtonTapped: likeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            image: image,
            userHasLiked: userHasLiked,
            imageHeight: imageHeight,
            likeButtonTapped: likeButtonTapped,
            likeButtonHidden: likeButtonHidden
        )
        
        // MARK: Bindind
        self.hangout$ = hangout$
        self.postImage$ = postImage$
    }
}
