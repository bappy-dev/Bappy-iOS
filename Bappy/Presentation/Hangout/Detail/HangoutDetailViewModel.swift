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
    
    struct Dependency {
        var currentUser: BappyUser
        var hangout: Hangout
        var postImage: UIImage?
        var mapImage: UIImage?
        let firebaseRepository: FirebaseRepository
        let userProfileRepository: UserProfileRepository
        let hangoutRepository: HangoutRepository
        
        var isUserParticipating: Bool {
            return hangout.joinedIDs
                .map(\.id)
                .contains(currentUser.id)
        }
        
        var hangoutButtonState: HangoutButton.State {
            switch hangout.state {
            case .preview: return .create
            case .closed: return .closed
            case .expired: return .expired
            case .available: return isUserParticipating ? .cancel : .join
            }
        }
        
        init(currentUser: BappyUser,
             hangout: Hangout,
             postImage: UIImage? = nil,
             mapImage: UIImage? = nil,
             firebaseRepository: FirebaseRepository = DefaultFirebaseRepository.shared,
             userProfileRepository: UserProfileRepository = DefaultUserProfileRepository(),
             hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.currentUser = currentUser
            self.hangout = hangout
            self.postImage = postImage
            self.mapImage = mapImage
            self.firebaseRepository = firebaseRepository
            self.userProfileRepository = userProfileRepository
            self.hangoutRepository = hangoutRepository
        }
    }
    
    struct SubViewModels {
        let imageSectionViewModel: HangoutImageSectionViewModel
        let mainSectionViewModel: HangoutMainSectionViewModel
        let mapSectionViewModel: HangoutMapSectionViewModel
        let planSectionViewModel: HangoutPlanSectionViewModel
        let participantsSectionViewModel: HangoutParticipantsSectionViewModel
    }
    
    struct Input {
        var backButtonTapped: AnyObserver<Void> // <-> View
        var hangoutButtonTapped: AnyObserver<Void> // <-> View
        var reviewButtonTapped: AnyObserver<Void> // <-> View
        var reportButtonTapped: AnyObserver<Void> // <-> View
        var imageHeight: AnyObserver<CGFloat> // <-> View
        var cancelAlertButtonTapped: AnyObserver<Void> // <-> View
        var likeButtonTapped: AnyObserver<Void> // <-> Child(Image)
        var mapButtonTapped: AnyObserver<Void> // <-> Child(Map)
        var selectedUserID: AnyObserver<String> // <-> Child(Participants)
    }
    
    struct Output {
        var popView: Signal<Void> // <-> View
        var imageHeight: Signal<CGFloat> // <-> Child(Map)
        var showOpenMapView: Signal<OpenMapPopupViewModel?> // <-> View
        var hangoutButtonState: Signal<HangoutButton.State> // <-> View
        var showReviewButton: Signal<Bool> // <-> View
        var showSignInAlert: Signal<String?> // <-> View
        var showCancelAlert: Signal<Alert?> // <-> View
        var showReviewView: Signal<WriteReviewViewModel?> // <-> View
        var showReportView: Signal<ReportViewModel?> // <-> View
        var showUserProfile: Signal<ProfileViewModel?> // <-> View
        var showCreateSuccessView: Signal<Void> // <-> View
        var showYellowLoader: Signal<Bool> // <-> View
        var showTranslucentLoader: Signal<Bool> // <-> View
        var hangout: Signal<Hangout?> // <-> Child(Image), CellViewModel
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let hangoutButtonState$: BehaviorSubject<HangoutButton.State>
    private let isUserParticipating$: BehaviorSubject<Bool>
    private let currentUser$: BehaviorSubject<BappyUser>
    private let hangout$: BehaviorSubject<Hangout>
    private let postImage$: BehaviorSubject<UIImage?>
    private let reasonsForReport$ = BehaviorSubject<[String]?>(value: nil)
    
    private let backButtonTapped$ = PublishSubject<Void>()
    private let hangoutButtonTapped$ = PublishSubject<Void>()
    private let reviewButtonTapped$ = PublishSubject<Void>()
    private let reportButtonTapped$ = PublishSubject<Void>()
    private let imageHeight$ = PublishSubject<CGFloat>()
    private let cancelAlertButtonTapped$ = PublishSubject<Void>()
    private let likeButtonTapped$ = PublishSubject<Void>()
    private let mapButtonTapped$ = PublishSubject<Void>()
    private let selectedUserID$ = PublishSubject<String>()
    
    private let showReviewButton$ = PublishSubject<Bool>()
    private let showCancelAlert$ = PublishSubject<Alert?>()
    private let showUserProfile$ = PublishSubject<ProfileViewModel?>()
    private let newParticipantsSectionView$ = PublishSubject<HangoutParticipantsSectionViewModel?>()
    private let showCreateSuccessView$ = PublishSubject<Void>()
    private let showYellowLoader$ = PublishSubject<Bool>()
    private let showTranslucentLoader$ = PublishSubject<Bool>()
    
    init(dependency: Dependency) {
        let imageDependency = HangoutImageSectionViewModel.Dependency(
            hangout: dependency.hangout,
            postImage: dependency.postImage)
        let mainDependency = HangoutMainSectionViewModel.Dependency(
            hangout: dependency.hangout,
            isUserParticipating: dependency.isUserParticipating)
        let mapDependency = HangoutMapSectionViewModel.Dependency(
            hangout: dependency.hangout,
            mapImage: dependency.mapImage)
        let planDependency = HangoutPlanSectionViewModel.Dependency(
            hangout: dependency.hangout)
        let participantsDependency = HangoutParticipantsSectionViewModel.Dependency(
            hangout: dependency.hangout)
        
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            imageSectionViewModel: HangoutImageSectionViewModel(dependency: imageDependency),
            mainSectionViewModel: HangoutMainSectionViewModel(dependency: mainDependency),
            mapSectionViewModel: HangoutMapSectionViewModel(dependency: mapDependency),
            planSectionViewModel: HangoutPlanSectionViewModel(dependency: planDependency),
            participantsSectionViewModel: HangoutParticipantsSectionViewModel(dependency: participantsDependency)
        )
        
        // MARK: Streams
        let hangoutButtonState$ = BehaviorSubject<HangoutButton.State>(value: dependency.hangoutButtonState)
        
        var isNeedToShowReviewButton = false
        if dependency.hangout.state == .expired
            && dependency.hangout.joinedIDs.contains(where: { $0.id == dependency.currentUser.id })
            && dependency.hangout.joinedIDs.count > 1 {
            let reviews = UserDefaults.standard.value(forKey: "Reviews") as? [String] ?? []
            isNeedToShowReviewButton = !reviews.contains(where: { $0 == dependency.hangout.id })
        }
        let showReviewButton$ = BehaviorSubject<Bool>(value: isNeedToShowReviewButton)
        
        let isUserParticipating$ = BehaviorSubject<Bool>(value: dependency.isUserParticipating)
        let currentUser$ = BehaviorSubject<BappyUser>(value: dependency.currentUser)
        let hangout$ = BehaviorSubject<Hangout>(value: dependency.hangout)
        let postImage$ = BehaviorSubject<UIImage?>(value: dependency.postImage)
        
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let imageHeight = imageHeight$
            .asSignal(onErrorJustReturn: 0)
        let showOpenMapView = mapButtonTapped$
            .map { _ -> OpenMapPopupViewModel in
                let dependency = OpenMapPopupViewModel.Dependency(
                    hangout: dependency.hangout)
                return OpenMapPopupViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let hangoutButtonState = hangoutButtonState$
            .asSignal(onErrorJustReturn: .expired)
        let showReviewButton = showReviewButton$
            .asSignal(onErrorJustReturn: false)
        let showSignInAlert = Observable
            .merge(
                hangoutButtonTapped$
                    .withLatestFrom(hangoutButtonState$)
                    .filter { $0 == .join }
                    .withLatestFrom(currentUser$)
                    .filter { $0.state == .anonymous }
                    .map { _ in "Please sign in to join!" },
                likeButtonTapped$
                    .withLatestFrom(currentUser$)
                    .filter { $0.state == .anonymous }
                    .map { _ in "Please sign in to like!" },
                selectedUserID$
                    .withLatestFrom(currentUser$)
                    .filter { $0.state == .anonymous}
                    .map { _ in "Sign in to check other's profiles!" }
            )
            .asSignal(onErrorJustReturn: nil)
        let showCancelAlert = showCancelAlert$
            .asSignal(onErrorJustReturn: nil)
        
        let showReviewView = reviewButtonTapped$
            .withLatestFrom(showReviewButton$)
            .filter { $0 }
            .withLatestFrom(hangout$)
            .withLatestFrom(currentUser$) { ($0, $1) }
            .map { (hangout, user) in
                var targetList = hangout.joinedIDs
                targetList.removeAll { $0.id == user.id }
                return (id: hangout.id, targetList: targetList)
            }
            .filter { $0.targetList.count > 0 }
            .map { hangout -> WriteReviewViewModel? in
                let writeReviewViewModel = WriteReviewViewModel(dependency: .init(hangoutID: hangout.id, targetList: hangout.targetList))
                return writeReviewViewModel
            }
            .asSignal(onErrorJustReturn: nil)
        
        let showReportView = reportButtonTapped$
            .withLatestFrom(hangoutButtonState$)
            .filter { $0 != .create }
            .withLatestFrom(hangout$.map(\.id))
            .withLatestFrom(reasonsForReport$) { id, list -> ReportViewModel? in
                guard let list = list else { return nil }
                let dependency = ReportViewModel.Dependency(
                    hangoutID: id, dropdownList: list)
                return ReportViewModel(dependency: dependency)
            }
            .asSignal(onErrorJustReturn: nil)
        let showUserProfile = showUserProfile$
            .asSignal(onErrorJustReturn: nil)
        let showCreateSuccessView = showCreateSuccessView$
            .asSignal(onErrorJustReturn: Void())
        let showYellowLoader = showYellowLoader$
            .asSignal(onErrorJustReturn: false)
        let showTranslucentLoader = showTranslucentLoader$
            .asSignal(onErrorJustReturn: false)
        let hangout = hangout$
            .skip(1)
            .map(Hangout?.init)
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            backButtonTapped: backButtonTapped$.asObserver(),
            hangoutButtonTapped: hangoutButtonTapped$.asObserver(),
            reviewButtonTapped: reviewButtonTapped$.asObserver(),
            reportButtonTapped: reportButtonTapped$.asObserver(),
            imageHeight: imageHeight$.asObserver(),
            cancelAlertButtonTapped: cancelAlertButtonTapped$.asObserver(),
            likeButtonTapped: likeButtonTapped$.asObserver(),
            mapButtonTapped: mapButtonTapped$.asObserver(),
            selectedUserID: selectedUserID$.asObserver()
        )
        
        self.output = Output(
            popView: popView,
            imageHeight: imageHeight,
            showOpenMapView: showOpenMapView,
            hangoutButtonState: hangoutButtonState,
            showReviewButton: showReviewButton,
            showSignInAlert: showSignInAlert,
            showCancelAlert: showCancelAlert,
            showReviewView: showReviewView,
            showReportView: showReportView,
            showUserProfile: showUserProfile,
            showCreateSuccessView: showCreateSuccessView,
            showYellowLoader: showYellowLoader,
            showTranslucentLoader: showTranslucentLoader,
            hangout: hangout
        )
        
        // MARK: Bindind
        self.hangoutButtonState$ = hangoutButtonState$
        self.isUserParticipating$ = isUserParticipating$
        self.currentUser$ = currentUser$
        self.hangout$ = hangout$
        self.postImage$ = postImage$
        
        // Cancel 버튼이 눌러졌을 때..
        hangoutButtonTapped$
            .withLatestFrom(hangoutButtonState$)
            .filter { $0 == .cancel }
            .map { [weak self] _ -> Alert in
                let title = "Will you really cancel?\nPlease leave the chat room first!"
                let message = "Bappy friends are looking\nforward to seeing you"
                let actionTitle = "Cancel"
                let action = Alert.Action(
                    actionTitle: actionTitle) {
                        self?.input.cancelAlertButtonTapped.onNext(Void())
                    }
                return Alert(
                    title: title,
                    message: message,
                    bappyStyle: .sad,
                    action: action
                )
            }
            .bind(to: showCancelAlert$)
            .disposed(by: disposeBag)
        
        // Create 버튼이 눌러졌을 때..
        let createResult = hangoutButtonTapped$
            .withLatestFrom(hangoutButtonState$)
            .filter { $0 == .create }
            .withLatestFrom(Observable.combineLatest(
                hangout$, postImage$.compactMap { $0?.pngData() ?? Data() }
            ))
            .do { [weak self] _ in self?.showYellowLoader$.onNext(true) }
            .flatMap(dependency.hangoutRepository.createHangout)
            .do { [weak self] _ in self?.showYellowLoader$.onNext(false) }
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        createResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        createResult
            .compactMap(getValue)
            .map { _ in }
            .bind(to: showCreateSuccessView$)
            .disposed(by: disposeBag)
        
        let joinResult = hangoutButtonTapped$
            .withLatestFrom(hangoutButtonState$)
            .filter { $0 == .join }
            .withLatestFrom(currentUser$) { ($0, $1) }
            .filter({ (info, user) in
                user.state == .normal
            })
            .map { $0.0 }
            .withLatestFrom(hangout$)
            .do { [weak self] _ in self?.showYellowLoader$.onNext(true) }
            .flatMap { dependency.hangoutRepository.joinHangout(hangoutID: $0.id) }
            .do(onNext: { [weak self] _ in self?.showYellowLoader$.onNext(false)
            }, onError: { [weak self] _ in self?.showYellowLoader$.onNext(false)})
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        joinResult
            .compactMap(getValue)
            .filter { $0 }
            .bind(onNext: { _ in hangoutButtonState$.onNext(.cancel) })
            .disposed(by: disposeBag)
        
        let cancelResult = cancelAlertButtonTapped$
            .withLatestFrom(hangoutButtonState$)
            .filter { $0 == .cancel }
            .withLatestFrom(hangout$)
            .do { [weak self] _ in self?.showYellowLoader$.onNext(true) }
            .flatMap { dependency.hangoutRepository.cancelHangout(hangoutID: $0.id) }
            .do(onNext: { [weak self] _ in self?.showYellowLoader$.onNext(false)
            }, onError: { [weak self] _ in self?.showYellowLoader$.onNext(false)})
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        cancelResult
            .compactMap(getValue)
            .filter { $0 }
            .bind(onNext: { _ in hangoutButtonState$.onNext(.join) })
            .disposed(by: disposeBag)
        
        hangoutButtonState$
            .skip(1)
            .filter { $0 == .join || $0 == .cancel }
            .map { state -> [Hangout.Info] in
                var newHangout = dependency.hangout
                if let idx = newHangout.joinedIDs.firstIndex(where: { $0.id == dependency.currentUser.id }) {
                    newHangout.joinedIDs.remove(at: idx)
                    if state == .cancel {
                        newHangout.joinedIDs.append(Hangout.Info(id: dependency.currentUser.id, imageURL: dependency.currentUser.profileImageURL!))
                    }
                }
                return newHangout.joinedIDs
            }.bind(to: subViewModels.participantsSectionViewModel.input.joinedIDs)
            .disposed(by: disposeBag)
        
        // FirebaseRemoteConfig로 행아웃 신고사유 리스트 불러오기
        let remoteConfigValuesResult = dependency.firebaseRepository.getRemoteConfigValues()
            .share()
        
        remoteConfigValuesResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        remoteConfigValuesResult
            .compactMap(getValue)
            .map(\.reasonsForReport)
            .bind(to: reasonsForReport$)
            .disposed(by: disposeBag)
        
        // 참가자 셀 탭 했을 때..
        let bappyUserResult = selectedUserID$
            .withLatestFrom(currentUser$) { ($0, $1)}
            .filter { $1.state == .normal }
            .map(\.0)
            .do { [weak self] _ in self?.showTranslucentLoader$.onNext(true) }
            .flatMap(dependency.userProfileRepository.fetchUserProfile)
            .do { [weak self] _ in self?.showTranslucentLoader$.onNext(false) }
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        bappyUserResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        // 탭한 참가자 프로필로 이동
        bappyUserResult
            .compactMap(getValue)
            .map { user -> ProfileViewModel in
                let dependency = ProfileViewModel.Dependency(
                    user: user,
                    authorization: .view)
                return ProfileViewModel(dependency: dependency)
            }
            .bind(to: showUserProfile$)
            .disposed(by: disposeBag)
        
        // 좋아요 버튼 Flow
        let likeFlow = likeButtonTapped$
            .withLatestFrom(hangout$) { (id: $1.id, like: !$1.userHasLiked) }
            .share()
        
        let likeResult = likeFlow
            .withLatestFrom(currentUser$) { ($0, $1) }
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
            .withLatestFrom(likeFlow)
            .withLatestFrom(hangout$) { (like: $0.like, hangout: $1) }
            .map { element -> Hangout in
                var hangout = element.hangout
                hangout.userHasLiked = element.like
                return hangout
            }
            .bind(to: hangout$)
            .disposed(by: disposeBag)
        
        // Child(Image)
        hangout
            .compactMap { $0 }
            .emit(to: subViewModels.imageSectionViewModel.input.hangout)
            .disposed(by: disposeBag)
        
        imageHeight
            .emit(to: subViewModels.imageSectionViewModel.input.imageHeight)
            .disposed(by: disposeBag)
        
        subViewModels.imageSectionViewModel.output.likeButtonTapped
            .emit(to: input.likeButtonTapped)
            .disposed(by: disposeBag)
        
        // Child(Map)
        subViewModels.mapSectionViewModel.output.mapButtonTapped
            .emit(to: input.mapButtonTapped)
            .disposed(by: disposeBag)
        
        // Child(Participants)
        subViewModels.participantsSectionViewModel.output.selectedUserID
            .compactMap { $0 }
            .emit(to: input.selectedUserID)
            .disposed(by: disposeBag)
    }
}
