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
        var isPreviewMode: Bool { hangout.state == .preview }
        var postImageURL: URL? { hangout.postImageURL }
        var userHasLiked: Bool { hangout.userHasLiked }
    }
    
    struct Input {
        var imageHeight: AnyObserver<CGFloat> // <-> Parent
    }
    
    struct Output {
        var imageURL: Signal<URL?> // <-> View
        var image: Signal<UIImage?> // <-> View
        var userHasLiked: Driver<Bool> // <-> View
        var imageHeight: Signal<CGFloat> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let isPreviewMode$: BehaviorSubject<Bool>
    private let postImageURL$: BehaviorSubject<URL?>
    private let postImage$: BehaviorSubject<UIImage?>
    private let userHasLiked$: BehaviorSubject<Bool>
    
    private let imageHeight$ = PublishSubject<CGFloat>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let isPreviewMode$ = BehaviorSubject<Bool>(value: dependency.isPreviewMode)
        let postImageURL$ = BehaviorSubject<URL?>(value: dependency.postImageURL)
        let postImage$ = BehaviorSubject<UIImage?>(value: dependency.postImage)
        let userHasLiked$ = BehaviorSubject<Bool>(value: dependency.userHasLiked)
        
        let imageURL = isPreviewMode$
            .filter { !$0 }
            .withLatestFrom(postImageURL$)
            .asSignal(onErrorJustReturn: nil)
        let image = isPreviewMode$
            .filter { $0 }
            .withLatestFrom(postImage$)
            .asSignal(onErrorJustReturn: nil)
        let userHasLiked = userHasLiked$
            .asDriver(onErrorJustReturn: false)
        let imageHeight = imageHeight$
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            imageHeight: imageHeight$.asObserver()
        )
        
        self.output = Output(
            imageURL: imageURL,
            image: image,
            userHasLiked: userHasLiked,
            imageHeight: imageHeight
        )
        
        // MARK: Bindind
        self.isPreviewMode$ = isPreviewMode$
        self.postImageURL$ = postImageURL$
        self.postImage$ = postImage$
        self.userHasLiked$ = userHasLiked$
    }
}
