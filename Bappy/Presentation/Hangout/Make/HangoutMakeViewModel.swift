//
//  HangoutMakeViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HangoutMakeViewModel: ViewModelType {
    
    struct Dependency {
        var currentUser: BappyUser
        let googleMapImageRepository: GoogleMapImageRepository
        var numOfPage: Int { 9 }
        var key: String { Bundle.main.googleMapAPIKey }
        
        init(currentUser: BappyUser,
             googleMapImageRepository: GoogleMapImageRepository = DefaultGoogleMapImageRepository()) {
            self.currentUser = currentUser
            self.googleMapImageRepository = googleMapImageRepository
        }
    }
    
    struct SubViewModels {
        let categoryViewModel: HangoutMakeCategoryViewModel
        let titleViewModel: HangoutMakeTitleViewModel
        let timeViewModel: HangoutMakeTimeViewModel
        let placeViewModel: HangoutMakePlaceViewModel
        let pictureViewModel: HangoutMakePictureViewModel
        let planViewModel: HangoutMakePlanViewModel
        let languageViewModel: HangoutMakeLanguageViewModel
        let openchatViewModel: HangoutMakeOpenchatViewModel
        let limitViewModel: HangoutMakeLimitViewModel
        let continueButtonViewModel: ContinueButtonViewModel
    }
    
    struct Input {
        var continueButtonTapped: AnyObserver<Void> // <-> Child
        var backButtonTapped: AnyObserver<Void> // <-> View
        var viewDidAppear: AnyObserver<Bool> // <-> View
        var keyboardWithButtonHeight: AnyObserver<CGFloat> // <-> View
        var categories: AnyObserver<[Hangout.Category]?> // <-> Child(Category)
        var title: AnyObserver<String?> // <-> Child(Title)
        var date: AnyObserver<Date?> // <-> Child(Date)
        var place: AnyObserver<Map?> // <-> Delegate(SearchMap)
        var picture: AnyObserver<UIImage?> // <-> Child(Picture)
        var plan: AnyObserver<String?> // <-> Child(Plan)
        var language: AnyObserver<Language?> // <-> Delegate(selectLanguage)
        var openchat: AnyObserver<String?> // <-> Child(Openchat)
        var limit: AnyObserver<Int?> // <-> Child(Limit)
        var isCategoriesValid: AnyObserver<Bool> // <-> Child(Category)
        var isTitleValid: AnyObserver<Bool> // <-> Child(Title)
        var isTimeValid: AnyObserver<Bool> // <-> Child(Date)
        var isPlaceValid: AnyObserver<Bool> // <-> Child(Place)
        var isPictureValid: AnyObserver<Bool> // <-> Child(Picture)
        var isPlanValid: AnyObserver<Bool> // <-> Child(Plan)
        var isLanguageValid: AnyObserver<Bool> // <-> Child(Language)
        var isOpenchatValid: AnyObserver<Bool> // <-> Child(Openchat)
        var isLimitValid: AnyObserver<Bool> // <-> Child(Limit)
    }
    
    struct Output {
        var shouldKeyboardHide: Signal<Void> // <-> View
        var page: Driver<Int> // <-> View
        var progression: Driver<CGFloat> // <-> View
        var initProgression: Signal<CGFloat> // <-> View
        var popView: Signal<Void> // <-> View
        var isContinueButtonEnabled: Signal<Bool> // <-> Child(Continue)
        var keyboardWithButtonHeight: Signal<CGFloat> // <-> Child
        var showSearchPlaceView: Signal<SearchPlaceViewModel?> // <-> View
        var showImagePicker: Signal<Void> // <-> View
        var showSelectLanguageView: Signal<SelectLanguageViewModel?> // <-> View
        var showLoader: Signal<Bool> // <-> View
        var showHangoutPreview: Signal<HangoutDetailViewModel?> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let page$ = BehaviorSubject<Int>(value: 0)
    private let currentUser$: BehaviorSubject<BappyUser>
    private let numOfPage$: BehaviorSubject<Int>
    private let key$: BehaviorSubject<String>
    private let continueButtonTapped$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let viewDidAppear$ = PublishSubject<Bool>()
    private let keyboardWithButtonHeight$ = PublishSubject<CGFloat>()
    private let categories$ = BehaviorSubject<[Hangout.Category]?>(value: [])
    private let title$ = BehaviorSubject<String?>(value: nil)
    private let date$ = BehaviorSubject<Date?>(value: nil)
    private let place$ = BehaviorSubject<Map?>(value: nil)
    private let picture$ = BehaviorSubject<UIImage?>(value: nil)
    private let plan$ = BehaviorSubject<String?>(value: nil)
    private let language$ = BehaviorSubject<Language?>(value: nil)
    private let openchat$ = BehaviorSubject<String?>(value: nil)
    private let limit$ = BehaviorSubject<Int?>(value: nil)
    private let isCategoriesValid$ = BehaviorSubject<Bool>(value: false)
    private let isTitleValid$ = BehaviorSubject<Bool>(value: false)
    private let isTimeValid$ = BehaviorSubject<Bool>(value: false)
    private let isPlaceValid$ = BehaviorSubject<Bool>(value: false)
    private let isPictureValid$ = BehaviorSubject<Bool>(value: true)
    private let isPlanValid$ = BehaviorSubject<Bool>(value: false)
    private let isLanguageValid$ = BehaviorSubject<Bool>(value: false)
    private let isOpenchatValid$ = BehaviorSubject<Bool>(value: false)
    private let isLimitValid$ = BehaviorSubject<Bool>(value: true)
    private let showSearchPlaceView$ = PublishSubject<SearchPlaceViewModel?>()
    private let showImagePicker$ = PublishSubject<Void>()
    private let showSelectLanguageView$ = PublishSubject<SelectLanguageViewModel?>()
    private let showLoader$ = PublishSubject<Bool>()
    private let showHangoutPreview$ = PublishSubject<HangoutDetailViewModel?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            categoryViewModel: HangoutMakeCategoryViewModel(),
            titleViewModel: HangoutMakeTitleViewModel(),
            timeViewModel: HangoutMakeTimeViewModel(),
            placeViewModel: HangoutMakePlaceViewModel(),
            pictureViewModel: HangoutMakePictureViewModel(),
            planViewModel: HangoutMakePlanViewModel(),
            languageViewModel: HangoutMakeLanguageViewModel(),
            openchatViewModel: HangoutMakeOpenchatViewModel(),
            limitViewModel: HangoutMakeLimitViewModel(),
            continueButtonViewModel: ContinueButtonViewModel()
        )
        
        // MARK: Streams
        let currentUser$ = BehaviorSubject<BappyUser>(value: dependency.currentUser)
        let numOfPage$ = BehaviorSubject<Int>(value: dependency.numOfPage)
        let key$ = BehaviorSubject<String>(value: dependency.key)
        
        let shouldKeyboardHide = Observable
            .merge(continueButtonTapped$, backButtonTapped$)
            .asSignal(onErrorJustReturn: Void())
        let page = page$
            .asDriver(onErrorJustReturn: .zero)
        let progression = page$.withLatestFrom(numOfPage$.filter { $0 != 0 },
                                                resultSelector: getProgression)
            .asDriver(onErrorJustReturn: .zero)
        let initProgression = viewDidAppear$
            .withLatestFrom(progression)
            .asSignal(onErrorJustReturn: 0)
        let backButtonTappedWithPage = backButtonTapped$
            .withLatestFrom(page$)
            .share()
        let popView = backButtonTappedWithPage
            .filter { $0 == 0 }
            .map { _ in }
            .asSignal(onErrorJustReturn: Void())
        
        let continueButtonTappedWithPage = continueButtonTapped$
            .withLatestFrom(Observable.combineLatest(page$, numOfPage$))
            .share()
        let isContinueButtonEnabled = Observable
            .merge(
                Observable.combineLatest(
                    page$.filter { $0 >= 0 && $0 <= 4 },
                    isCategoriesValid$, isTitleValid$, isTimeValid$, isPlaceValid$, isPictureValid$,
                    resultSelector: shouldButtonEnabledWithFirst
                ),
                Observable.combineLatest(
                    page$.filter { $0 >= 5 && $0 <= 8 },
                    isPlanValid$, isLanguageValid$, isOpenchatValid$, isLimitValid$,
                    resultSelector: shouldButtonEnabledWithSecond
                )
            )
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: false)
        let keyboardWithButtonHeight = keyboardWithButtonHeight$
            .asSignal(onErrorJustReturn: 0)
        let showSearchPlaceView = showSearchPlaceView$
            .asSignal(onErrorJustReturn: nil)
        let showImagePicker = showImagePicker$
            .asSignal(onErrorJustReturn: Void())
        let showSelectLanguageView = showSelectLanguageView$
            .asSignal(onErrorJustReturn: nil)
        let showLoader = showLoader$
            .asSignal(onErrorJustReturn: false)
        let showHangoutPreview = showHangoutPreview$
            .asSignal(onErrorJustReturn: nil)
        
        // MARK: Input & Output
        self.input = Input(
            continueButtonTapped: continueButtonTapped$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver(),
            viewDidAppear: viewDidAppear$.asObserver(),
            keyboardWithButtonHeight: keyboardWithButtonHeight$.asObserver(),
            categories: categories$.asObserver(),
            title: title$.asObserver(),
            date: date$.asObserver(),
            place: place$.asObserver(),
            picture: picture$.asObserver(),
            plan: plan$.asObserver(),
            language: language$.asObserver(),
            openchat: openchat$.asObserver(),
            limit: limit$.asObserver(),
            isCategoriesValid: isCategoriesValid$.asObserver(),
            isTitleValid: isTitleValid$.asObserver(),
            isTimeValid: isTimeValid$.asObserver(),
            isPlaceValid: isPlaceValid$.asObserver(),
            isPictureValid: isPictureValid$.asObserver(),
            isPlanValid: isPlanValid$.asObserver(),
            isLanguageValid: isLanguageValid$.asObserver(),
            isOpenchatValid: isOpenchatValid$.asObserver(),
            isLimitValid: isLimitValid$.asObserver()
        )
        
        self.output = Output(
            shouldKeyboardHide: shouldKeyboardHide,
            page: page,
            progression: progression,
            initProgression: initProgression,
            popView: popView,
            isContinueButtonEnabled: isContinueButtonEnabled,
            keyboardWithButtonHeight: keyboardWithButtonHeight,
            showSearchPlaceView: showSearchPlaceView,
            showImagePicker: showImagePicker,
            showSelectLanguageView: showSelectLanguageView,
            showLoader: showLoader,
            showHangoutPreview: showHangoutPreview
        )
        
        // MARK: Bindind
        self.currentUser$ = currentUser$
        self.numOfPage$ = numOfPage$
        self.key$ = key$
        
        let hangout = Observable
            .combineLatest(
                Observable.combineLatest(
                    categories$.compactMap { $0 },
                    title$.compactMap { $0 },
                    date$.compactMap { $0 },
                    place$.compactMap { $0 }
                ),
                Observable.combineLatest(
                    plan$.compactMap { $0 },
                    language$.compactMap { $0 },
                    openchat$.compactMap { $0 },
                    limit$.compactMap { $0 }
                )
            )
            .map { first, second -> Hangout in
                return Hangout(id: "preview",
                        state: .preview,
                        title: first.1,
                        meetTime: first.2,
                        language: second.1,
                        plan: second.0,
                        limitNumber: second.3,
                        categories: first.0,
                               place: .init(name: first.3.name, address: first.3.address, latitude: first.3.coordinates.latitude, longitude: first.3.coordinates.longitude),
                        postImageURL: URL(string: ""),
                        openchatURL: second.2,
                        joinedIDs: [],
                        likedIDs: [],
                        userHasLiked: false)
            }
            .share()
        
        // Goolge Map Image 불러오기
        let result = continueButtonTapped$
            .withLatestFrom(Observable.combineLatest(page$, numOfPage$))
            .filter { $0.0 + 1 == $0.1 }
            .withLatestFrom(Observable.combineLatest(
                key$, place$.compactMap { $0.map(\.coordinates) }
            ))
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .map(dependency.googleMapImageRepository.fetchMapImageData)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .flatMap { $0 }
            .share()
        
        result
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)

        let mapImage = result
            .compactMap(getValue)
            .map(UIImage.init)
            .share()
        
        // 행아웃 Preview 모드
        mapImage
            .withLatestFrom(Observable.combineLatest(
                currentUser$, hangout, picture$
            )) { (mapImage: $0, user: $1.0, hangout: $1.1, postImage: $1.2) }
            .map { element -> HangoutDetailViewModel in
                let realImage = element.postImage == nil ? Constant.hangoutDefaultImages.randomElement()! : element.postImage
                let dependency = HangoutDetailViewModel.Dependency(
                    currentUser: element.user,
                    hangout: element.hangout,
                    postImage: realImage,
                    mapImage: element.mapImage)
                return HangoutDetailViewModel(dependency: dependency)
            }
            .bind(to: showHangoutPreview$)
            .disposed(by: disposeBag)

        
        // 다음 페이지
        continueButtonTappedWithPage
            .filter { $0.0 + 1 < $0.1 }
            .map { $0.0 + 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        // 이전 페이지
        backButtonTappedWithPage
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
        // Child(Category)
        subViewModels.categoryViewModel.output.categories
            .emit(to: categories$)
            .disposed(by: disposeBag)
        
        subViewModels.categoryViewModel.output.isValid
            .drive(isCategoriesValid$)
            .disposed(by: disposeBag)
        
        // Child(Title)
        keyboardWithButtonHeight
            .emit(to: subViewModels.titleViewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
        
        subViewModels.titleViewModel.output.title
            .emit(to: title$)
            .disposed(by: disposeBag)
        
        subViewModels.titleViewModel.output.isValid
            .emit(to: isTitleValid$)
            .disposed(by: disposeBag)
        
        // Child(Time)
        subViewModels.timeViewModel.output.date
            .distinctUntilChanged()
            .drive(date$)
            .disposed(by: disposeBag)
        
        subViewModels.timeViewModel.output.isValid
            .emit(to: isTimeValid$)
            .disposed(by: disposeBag)
        
        // Child(Place)
        place$
            .compactMap { $0 }
            .bind(to: subViewModels.placeViewModel.input.map)
            .disposed(by: disposeBag)
        
        subViewModels.placeViewModel.output.showSearchPlaceView
            .map { _ -> SearchPlaceViewModel in
                let viewModel = SearchPlaceViewModel()
                viewModel.delegate = self
                return viewModel
            }
            .emit(to: showSearchPlaceView$)
            .disposed(by: disposeBag)
        
        subViewModels.placeViewModel.output.isValid
            .emit(to: isPlaceValid$)
            .disposed(by: disposeBag)
        
        // Child(Picture)
        picture$
            .compactMap { $0 }
            .bind(to: subViewModels.pictureViewModel.input.picture)
            .disposed(by: disposeBag)
        
        subViewModels.pictureViewModel.output.pictureButtonTapped
            .emit(to: showImagePicker$)
            .disposed(by: disposeBag)
        
        subViewModels.pictureViewModel.output.isValid
            .emit(to: isPictureValid$)
            .disposed(by: disposeBag)
        
        // Child(Plan)
        keyboardWithButtonHeight
            .emit(to: subViewModels.planViewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
        
        subViewModels.planViewModel.output.plan
            .emit(to: plan$)
            .disposed(by: disposeBag)
        
        subViewModels.planViewModel.output.isValid
            .emit(to: isPlanValid$)
            .disposed(by: disposeBag)
        
        // Child(Language)
        language$
            .compactMap { $0 }
            .bind(to: subViewModels.languageViewModel.input.language)
            .disposed(by: disposeBag)
        
        subViewModels.languageViewModel.output.showSelectLanguageView
            .map { _ -> SelectLanguageViewModel in
                let viewModel = SelectLanguageViewModel()
                viewModel.delegate = self
                return viewModel
            }
            .emit(to: showSelectLanguageView$)
            .disposed(by: disposeBag)
        
        subViewModels.languageViewModel.output.isValid
            .emit(to: isLanguageValid$)
            .disposed(by: disposeBag)
        
        // Child(Openchat)
        keyboardWithButtonHeight
            .emit(to: subViewModels.openchatViewModel.input.keyboardWithButtonHeight)
            .disposed(by: disposeBag)
        
        subViewModels.openchatViewModel.output.openchatText
            .emit(to: openchat$)
            .disposed(by: disposeBag)
        
        subViewModels.openchatViewModel.output.isValid
            .emit(to: isOpenchatValid$)
            .disposed(by: disposeBag)
        
        // Child(Limit)
        subViewModels.limitViewModel.output.limit
            .emit(to: limit$)
            .disposed(by: disposeBag)
        
        // ContinueButton
        output.isContinueButtonEnabled
            .emit(to: subViewModels.continueButtonViewModel.input.isButtonEnabled)
            .disposed(by: disposeBag)
        
        subViewModels.continueButtonViewModel.output.continueButtonTapped
            .emit(to: continueButtonTapped$)
            .disposed(by: disposeBag)
    }
}

private func getProgression(currentPage: Int, numOfPage: Int) -> CGFloat {
    return CGFloat(currentPage + 1) / CGFloat(numOfPage)
}

private func shouldButtonEnabledWithFirst(page: Int, isCategoryValid: Bool, isTitleValid: Bool, isTimeValid: Bool, isPlaceValid: Bool, isPictureValid: Bool) -> Bool {
    switch page {
    case 0: return isCategoryValid
    case 1: return isTitleValid
    case 2: return isTimeValid
    case 3: return isPlaceValid
    case 4: return isPictureValid
    default: return false}
}

private func shouldButtonEnabledWithSecond(page: Int, isPlanValid: Bool, isLanguageValid: Bool, isOpenchatValid: Bool, isLimitValid: Bool) -> Bool {
    switch page {
    case 5: return isPlanValid
    case 6: return isLanguageValid
    case 7: return isOpenchatValid
    case 8: return isLimitValid
    default: return false}
}

// MARK: - SearchPlaceViewModelDelegate
extension HangoutMakeViewModel: SearchPlaceViewModelDelegate {
    func mapSelected(map: Map) {
        input.place.onNext(map)
    }
}

// MARK: - SelectLanguageViewModelDelegate
extension HangoutMakeViewModel: SelectLanguageViewModelDelegate {    
    func languageSelected(language: Language) {
        input.language.onNext(language)
    }
}
