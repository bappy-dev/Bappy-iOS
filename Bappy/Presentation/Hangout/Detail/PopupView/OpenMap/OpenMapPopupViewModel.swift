//
//  OpenMapPopupViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/25.
//

import UIKit
import RxSwift
import RxCocoa

final class OpenMapPopupViewModel: ViewModelType {
    
    struct Dependency {
        var googleMapURL: URL?
        var kakaoMapURL: URL?
    }
    
    struct Input {
        var googleMapButtonTapped: AnyObserver<Void>
        var kakaoMapButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var openGoogleMap: Signal<URL?>
        var openKakaoMap: Signal<URL?>
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let googleMapURL$: BehaviorSubject<URL?>
    private let kakaoMapURL$: BehaviorSubject<URL?>
    
    private let googleMapButtonTapped$ = PublishSubject<Void>()
    private let kakaoMapButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let googleMapURL$ = BehaviorSubject<URL?>(value: dependency.googleMapURL)
        let kakaoMapURL$ = BehaviorSubject<URL?>(value: dependency.kakaoMapURL)
        
        let openGoogleMap = googleMapButtonTapped$
            .withLatestFrom(googleMapURL$)
            .asSignal(onErrorJustReturn: dependency.googleMapURL)
        let openKakaoMap = kakaoMapButtonTapped$
            .withLatestFrom(kakaoMapURL$)
            .asSignal(onErrorJustReturn: dependency.kakaoMapURL)
        
        
        // MARK: Input & Output
        self.input = Input(
            googleMapButtonTapped: googleMapButtonTapped$.asObserver(),
            kakaoMapButtonTapped: kakaoMapButtonTapped$.asObserver()
        )
        
        self.output = Output(
            openGoogleMap: openGoogleMap,
            openKakaoMap: openKakaoMap
        )
        
        // MARK: Bindind
        self.googleMapURL$ = googleMapURL$
        self.kakaoMapURL$ = kakaoMapURL$
    }
}
