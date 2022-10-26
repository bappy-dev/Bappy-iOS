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
        var hangout: Hangout
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
    
    private let hangout$: BehaviorSubject<Hangout>
    
    private let googleMapButtonTapped$ = PublishSubject<Void>()
    private let kakaoMapButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let hangout$ = BehaviorSubject<Hangout>(value: dependency.hangout)
        
        let openGoogleMap = googleMapButtonTapped$
            .withLatestFrom(hangout$)
            .map {
                getURL(
                    baseURL: GOOGLE_MAP_DIR_BASEURL,
                    path: "?",
                    queries: [
                        "api=1",
                        "destination=\($0.place.name)"
                    ])
            }
            .asSignal(onErrorJustReturn: nil)
        let openKakaoMap = kakaoMapButtonTapped$
            .withLatestFrom(hangout$)
            .map {
                getURL(
                    baseURL: KAKAO_MAP_DIR_BASEURL,
                    path: nil,
                    queries: [
                        "\($0.place.name),\($0.place.coordinates.latitude),\($0.place.coordinates.longitude)"
                    ])
            }
            .asSignal(onErrorJustReturn: nil)
        
        
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
        self.hangout$ = hangout$
    }
}

private func getURL(baseURL: String, path: String?, queries: [String]?) -> URL? {
    var urlString = baseURL
    if let path = path { urlString += path }
    if let queries = queries { urlString += queries.joined(separator: "&") }
    
    return urlString
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        .flatMap { URL(string: $0) }
}
