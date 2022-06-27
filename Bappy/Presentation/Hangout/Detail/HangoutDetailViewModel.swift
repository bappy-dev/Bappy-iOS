//
//  HangoutDetailViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutDetailViewModel: ViewModelType {
    
    struct SubViewModels {
        let imageSectionViewModel: HangoutImageSectionViewModel
        let mainSectionViewModel: HangoutMainSectionViewModel
        let mapSectionViewModel: HangoutMapSectionViewModel
        let planSectionViewModel: HangoutPlanSectionViewModel
        let participantsSectionViewModel: HangoutParticipantsSectionViewModel
    }
    
    struct Dependency {
        var currentUser: User
        var hangout: Hangout
        var postImage: UIImage?
        var mapImage: UIImage?
        var isUserParticipating: Bool {
            return hangout.participantIDs
                .map { $0.id }
                .contains(currentUser.id)
        }
        var hangoutButtonState: HangoutButton.State {
            switch hangout.state {
            case .preview: return .create
            case .closed: return .closed
            case .expired: return . expired
            case .available: return isUserParticipating ? .cancel : .join
            }
        }
        
        init(currentUser: User, hangout: Hangout, postImage: UIImage? = nil, mapImage: UIImage? = nil) {
            self.currentUser = currentUser
            self.hangout = hangout
            self.postImage = postImage
            self.mapImage = mapImage
        }
    }
    
    struct Input {
        var backButtonTapped: AnyObserver<Void> // <-> View
        var hangoutButtonTapped: AnyObserver<Void> // <-> View
        var imageHeight: AnyObserver<CGFloat> // <-> View
        var mapButtonTapped: AnyObserver<Void> // <-> Child(Map)
    }
    
    struct Output {
        var popView: Signal<Void> // <-> View
        var imageHeight: Signal<CGFloat> // <-> Child(Map)
        var showOpenMapView: Signal<OpenMapPopupViewModel> // <-> View
        var hangoutButtonState: Signal<HangoutButton.State> // <-> View
        var showSigninPopupView: Signal<Void> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let hangoutButtonState$: BehaviorSubject<HangoutButton.State>
    private let isUserParticipating$: BehaviorSubject<Bool>
    private let currentUser$: BehaviorSubject<User>
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let hangoutButtonTapped$ = PublishSubject<Void>()
    private let imageHeight$ = PublishSubject<CGFloat>()
    private let mapButtonTapped$ = PublishSubject<Void>()
    
    init(dependency: Dependency) {
        let imageDependency = HangoutImageSectionViewModel.Dependency(
            isPreviewMode: dependency.hangout.state == .preview,
            postImageURL: dependency.hangout.postImageURL,
            postImage: dependency.postImage,
            userHasLiked: dependency.hangout.userHasLiked
        )
        let mainDependency = HangoutMainSectionViewModel.Dependency(
            isUserParticipating: dependency.isUserParticipating,
            title: dependency.hangout.title,
            meetTime: dependency.hangout.meetTime,
            language: dependency.hangout.language,
            placeName: dependency.hangout.placeName,
            openchatURL: dependency.hangout.openchatURL
        )
        let mapDependency = HangoutMapSectionViewModel.Dependency(
            isPreviewModel: dependency.hangout.state == .preview,
            placeName: dependency.hangout.placeName,
            mapImageURL: dependency.hangout.mapImageURL,
            mapImage: dependency.mapImage
        )
        let planDependency = HangoutPlanSectionViewModel.Dependency(
            plan: dependency.hangout.plan
        )
        let participantsDependency = HangoutParticipantsSectionViewModel.Dependency(
            limitNumber: dependency.hangout.limitNumber,
            participantIDs: dependency.hangout.participantIDs
        )
        
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            imageSectionViewModel: HangoutImageSectionViewModel(dependency: imageDependency),
            mainSectionViewModel: HangoutMainSectionViewModel(dependency: mainDependency),
            mapSectionViewModel: HangoutMapSectionViewModel(dependency: mapDependency),
            planSectionViewModel: HangoutPlanSectionViewModel(dependency: planDependency),
            participantsSectionViewModel: HangoutParticipantsSectionViewModel(dependency: participantsDependency)
        )
        
        // Streams
        let hangoutButtonState$ = BehaviorSubject<HangoutButton.State>(value: dependency.hangoutButtonState)
        let isUserParticipating$ = BehaviorSubject<Bool>(value: dependency.isUserParticipating)
        let currentUser$ = BehaviorSubject<User>(value: dependency.currentUser)
        
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let imageHeight = imageHeight$
            .asSignal(onErrorJustReturn: 0)
        let showOpenMapView = mapButtonTapped$
            .map { _ -> OpenMapPopupViewModel in
                let dependency = OpenMapPopupViewModel.Dependency(
                    googleMapURL: dependency.hangout.googleMapURL,
                    kakaoMapURL: dependency.hangout.kakaoMapURL)
                return OpenMapPopupViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: OpenMapPopupViewModel(dependency: .init(
                googleMapURL: dependency.hangout.googleMapURL,
                kakaoMapURL: dependency.hangout.kakaoMapURL
            )))
        let hangoutButtonState = hangoutButtonState$
            .asSignal(onErrorJustReturn: .expired)
        let showSigninPopupView = hangoutButtonTapped$
            .withLatestFrom(hangoutButtonState$)
            .filter { $0 == .join }
            .withLatestFrom(currentUser$)
            .filter { $0.state == .anonymous }
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        
        // Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            hangoutButtonTapped: hangoutButtonTapped$.asObserver(),
            imageHeight: imageHeight$.asObserver(),
            mapButtonTapped: mapButtonTapped$.asObserver()
        )
        
        self.output = Output(
            popView: popView,
            imageHeight: imageHeight,
            showOpenMapView: showOpenMapView,
            hangoutButtonState: hangoutButtonState,
            showSigninPopupView: showSigninPopupView
        )
        
        // Bindind
        self.hangoutButtonState$ = hangoutButtonState$
        self.isUserParticipating$ = isUserParticipating$
        self.currentUser$ = currentUser$
        
        // Child(Image)
        imageHeight
            .emit(to: subViewModels.imageSectionViewModel.input.imageHeight)
            .disposed(by: disposeBag)
        
        // Child(Map)
        subViewModels.mapSectionViewModel.output.mapButtonTapped
            .emit(to: mapButtonTapped$)
            .disposed(by: disposeBag)
    }
}
