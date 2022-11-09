//
//  HangoutCellViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/07.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutCellViewModel: ViewModelType {
    
    struct Dependency {
        var user: BappyUser
        var hangout: Hangout
        let hangoutRepository: HangoutRepository
        let googleMapImageRepository: GoogleMapImageRepository
        var dateFormat: String { "dd. MMM. HH:mm" }
        
        init(user: BappyUser,
             hangout: Hangout,
             hangoutRepository: HangoutRepository = DefaultHangoutRepository(),
             googleMapImageRepository: GoogleMapImageRepository = DefaultGoogleMapImageRepository()) {
            self.user = user
            self.hangout = hangout
            self.hangoutRepository = hangoutRepository
            self.googleMapImageRepository = googleMapImageRepository
        }
    }
    
    struct Input {
        var hangout: AnyObserver<Hangout> // <-> DetailViewModel
        var moreButtonTapped: AnyObserver<Void> // <-> View
        var likeButtonTapped: AnyObserver<Void> // <-> View
        var doubleTap: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var title: Driver<String?> // <-> View
        var time: Driver<String?> // <-> View
        var place: Driver<String?> // <-> View
        var postImageURL: Driver<URL?> // <-> View
        var joinedUsers: Driver<[Hangout.Info]>
        var userHasLiked: Driver<Bool> // <-> View
        var state: Driver<Hangout.State?> // <-> View
        var showAnimation: Signal<Void> // <-> View
        var showDetailView: Signal<HangoutDetailViewModel?> // <-> Parent
        var showSignInAlert: Signal<String?> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
    private let hangout$: BehaviorSubject<Hangout>
    
    private let moreButtonTapped$ = PublishSubject<Void>()
    private let likeButtonTapped$ = PublishSubject<Void>()
    private let doubleTap$ = PublishSubject<Void>()
    
    private let showAnimation$ = PublishSubject<Void>()
    private let showDetailView$ = PublishSubject<HangoutDetailViewModel?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        let hangout$ = BehaviorSubject<Hangout>(value: dependency.hangout)
        let key$ = BehaviorSubject<String>(value: Bundle.main.googleMapAPIKey)
        
        let title = hangout$
            .map(\.title)
            .map(String?.init)
            .asDriver(onErrorJustReturn: nil)
        let time = hangout$
            .map { $0.meetTime.toString(dateFormat: dependency.dateFormat) }
            .asDriver(onErrorJustReturn: nil)
        let place = hangout$
            .map(\.place.name)
            .map(String?.init)
            .asDriver(onErrorJustReturn: nil)
        let postImageURL = hangout$
            .map(\.postImageURL)
            .asDriver(onErrorJustReturn: URL(string: BAPPY_API_BASEURL)!)
        let joinedUsers = hangout$
            .map { $0.joinedIDs }
            .asDriver(onErrorJustReturn: [])
        let userHasLiked = hangout$
            .map(\.userHasLiked)
            .asDriver(onErrorJustReturn: false)
        let state = hangout$
            .map(\.state)
            .map(Hangout.State?.init)
            .asDriver(onErrorJustReturn: nil)
        let showAnimation = showAnimation$
            .asSignal(onErrorJustReturn: Void())
        let showDetailView = showDetailView$
            .asSignal(onErrorJustReturn: nil)
        
        let showSignInAlert = likeButtonTapped$
            .withLatestFrom(user$)
            .filter { $0.state == .anonymous }
            .map { _ in "Please sign in to like!" }
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            hangout: hangout$.asObserver(),
            moreButtonTapped: moreButtonTapped$.asObserver(),
            likeButtonTapped: likeButtonTapped$.asObserver(),
            doubleTap: doubleTap$.asObserver()
        )
        
        self.output = Output(
            title: title,
            time: time,
            place: place,
            postImageURL: postImageURL,
            joinedUsers: joinedUsers,
            userHasLiked: userHasLiked,
            state: state,
            showAnimation: showAnimation,
            showDetailView: showDetailView,
            showSignInAlert: showSignInAlert
        )
        
        // MARK: Bindind
        self.user$ = user$
        self.hangout$ = hangout$
        
        // 좋아요 Flow
        let likeFlow = Observable
            .merge(likeButtonTapped$, doubleTap$)
            .withLatestFrom(hangout$) { (id: $1.id, userHasLiked: !$1.userHasLiked) }
            .share()
        
        let likeResult = likeFlow
            .withLatestFrom(user$) { ($0, $1) }
            .filter({ (info, user) in
                user.state == .normal
            })
            .map { $0.0 }
            .flatMap(dependency.hangoutRepository.likeHangout)
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        likeResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        likeResult
            .compactMap(getValue)
            .withLatestFrom(likeFlow.map(\.userHasLiked))
            .withLatestFrom(hangout$) { (like: $0, hangout: $1) }
            .withLatestFrom(user$) { (like: $0.0, hangout: $0.1, user: $1) }
            .map { element -> Hangout in
                var hangout = element.hangout
                hangout.userHasLiked = element.like
                
                if let idx = hangout.likedIDs.firstIndex(where: { $0.id == element.user.id }) {
                    hangout.likedIDs.remove(at: idx)
                }
                
                if hangout.userHasLiked {
                    hangout.likedIDs.append(Hangout.Info(id: element.user.id, imageURL: element.user.profileImageURL))
                }
                
                return hangout
            }
            .bind(to: hangout$)
            .disposed(by: disposeBag)
        
        likeResult
            .compactMap(getValue)
            .withLatestFrom(likeFlow.map(\.userHasLiked))
            .filter { $0 }
            .map { _ in }
            .bind(to: showAnimation$)
            .disposed(by: disposeBag)
        
        let result = moreButtonTapped$
            .withLatestFrom(Observable.combineLatest(
                key$, hangout$.map { $0.place.coordinates }
            ))
            .flatMap(dependency.googleMapImageRepository.fetchMapImageData)
            .share()
        
        result
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        let mapImage = result
            .compactMap(getValue)
            .map(UIImage.init)
            .share()
        
        // 상세뷰와 Like 맞추기
        mapImage
            .withLatestFrom(hangout$) { (image: $0, hangout: $1)}
            .withLatestFrom(user$) { (image: $0.image, hangout: $0.hangout, user: $1)}
            .map { [weak self] element -> HangoutDetailViewModel? in
                guard let self = self else { return nil }
                let dependency = HangoutDetailViewModel.Dependency(
                    currentUser: element.user, hangout: element.hangout, mapImage: element.image)
                let viewModel = HangoutDetailViewModel(dependency: dependency)
                viewModel.output.hangout
                    .compactMap { $0 }
                    .emit(to: self.input.hangout)
                    .disposed(by: viewModel.disposeBag)
                return viewModel
            }
            .bind(to: showDetailView$)
            .disposed(by: disposeBag)
    }
}
