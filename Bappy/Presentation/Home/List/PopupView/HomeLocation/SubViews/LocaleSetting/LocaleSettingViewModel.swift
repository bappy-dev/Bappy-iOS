//
//  LocaleSettingViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/12.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class LocaleSettingViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
        let locationRepsitory: CLLocationRepository
        
        init(bappyAuthRepository: BappyAuthRepository = DefaultBappyAuthRepository.shared,
             locationRepsitory: CLLocationRepository = DefaultCLLocationRepository.shared) {
            self.bappyAuthRepository = bappyAuthRepository
            self.locationRepsitory = locationRepsitory
        }
    }
    
    struct SubViewModels {
        let headerViewModel: LocaleSettingHeaderViewModel
    }
    
    struct Input {
        var viewWillAppear: AnyObserver<Bool> // <-> View
        var editingDidBegin: AnyObserver<Void> // <-> View
        var closeButtonTapped: AnyObserver<Void> // <-> View
        var itemSelected: AnyObserver<IndexPath> // <-> View
        var itemDeleted: AnyObserver<IndexPath> // <-> View
        var localeButtonTapped: AnyObserver<Void> // <-> Child
    }
    
    struct Output {
        var closeButtonTapped: Signal<Void> // <-> Parent
        var localeSettingSection: Driver<[LocaleSettingSection]> // <-> View
        var showSearchView: Signal<LocaleSearchViewModel?> // <-> View
        var showAuthorizationAlert: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser?>
    private let authorization$: BehaviorSubject<CLAuthorizationStatus>
    private let userGPSWithAuthorization$: BehaviorSubject<(gps: Bool, authorization: CLAuthorizationStatus)>
    private let locations$ = BehaviorSubject<[Location]>(value: [])
    
    private let viewWillAppear$ = PublishSubject<Bool>()
    private let editingDidBegin$ = PublishSubject<Void>()
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let itemSelected$ = PublishSubject<IndexPath>()
    private let itemDeleted$ = PublishSubject<IndexPath>()
    private let localeButtonTapped$ = PublishSubject<Void>()
    
    private let localeSettingSection$ = BehaviorSubject<[LocaleSettingSection]>(value: [.init(items: [])])
    private let showSearchView$ = PublishSubject<LocaleSearchViewModel?>()
    private let showAuthorizationAlert$ = PublishSubject<Void>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            headerViewModel: LocaleSettingHeaderViewModel(dependency: .init())
        )
        
        // MARK: Streams
        let user$ = dependency.bappyAuthRepository.currentUser
        let authorization$ = dependency.locationRepsitory.authorization
        let userGPSWithAuthorization$ = BehaviorSubject<(gps: Bool, authorization: CLAuthorizationStatus)>(value: (gps: false, authorization: .notDetermined))
        
        let closeButtonTapped = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let localeSettingSection = localeSettingSection$
            .asDriver(onErrorJustReturn: [])
        let showSearchView = showSearchView$
            .asSignal(onErrorJustReturn: nil)
        let showAuthorizationAlert = showAuthorizationAlert$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            viewWillAppear: viewWillAppear$.asObserver(),
            editingDidBegin: editingDidBegin$.asObserver(),
            closeButtonTapped: closeButtonTapped$.asObserver(),
            itemSelected: itemSelected$.asObserver(),
            itemDeleted: itemDeleted$.asObserver(),
            localeButtonTapped: localeButtonTapped$.asObserver()
        )
        
        self.output = Output(
            closeButtonTapped: closeButtonTapped,
            localeSettingSection: localeSettingSection,
            showSearchView: showSearchView,
            showAuthorizationAlert: showAuthorizationAlert
        )
        
        // MARK: Bindind
        self.user$ = user$
        self.authorization$ = authorization$
        self.userGPSWithAuthorization$ = userGPSWithAuthorization$
        
        Observable
            .combineLatest(
                user$.compactMap(\.?.isUserUsingGPS),
                authorization$
            ) { (gps: $0, authorization: $1) }
            .bind(to: userGPSWithAuthorization$)
            .disposed(by: disposeBag)
        
        // [Location] -> [LocaleSettingSection]
        locations$
            .skip(1)
            .withLatestFrom(userGPSWithAuthorization$) { (locations: $0, gpsWithAuthorization: $1) }
            .map { element -> [Location] in
                let gps = element.gpsWithAuthorization.gps
                let authorization = element.gpsWithAuthorization.authorization
                return element.locations.map { location -> Location in
                    var location = location
                    location.isSelected = location.isSelected && (!gps || authorization != .authorizedWhenInUse)
                    return location
                }
            }
            .withLatestFrom(localeSettingSection$) { locations, sections -> [LocaleSettingSection] in
                var sections = sections
                sections[0].items = locations
                return sections
            }
            .bind(to: localeSettingSection$)
            .disposed(by: disposeBag)
        
        // GPS On 상태로 바뀔 시 Location 선택 모두 False 전환
        user$
            .compactMap(\.?.isUserUsingGPS)
            .filter { $0 }
            .withLatestFrom(locations$)
            .map { locations -> [Location] in
                var locations = locations
                locations = locations.map { location -> Location in
                    var location = location
                    location.isSelected = false
                    return location
                }
                return locations
            }
            .bind(to: locations$)
            .disposed(by: disposeBag)
        
        
        // 검색창 눌렀을 때 검색뷰 띄우기
        editingDidBegin$
            .map { _ in LocaleSearchViewModel() }
            .bind(to: showSearchView$)
            .disposed(by: disposeBag)
        
        // viewWillAppear 호출 시 데이터 새로 불러오기
        let locationsResult = viewWillAppear$
            .map { _ in }
            .flatMap(dependency.bappyAuthRepository.fetchLocations)
            .share()
        
        locationsResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        locationsResult
            .compactMap(getValue)
            .bind(to: locations$)
            .disposed(by: disposeBag)
        
        // 4가지 상태(GPS, Authorization): Off/Off, On/Off, Off/On, On/On
        let startFlow = localeButtonTapped$
            .withLatestFrom(userGPSWithAuthorization$)
            .share()
        
        // 위치권한 거부 상태에 버튼 사용 시 Alert 띄우기
        startFlow
            .filter { $0.authorization == .denied }
            .map { _ in }
            .bind(to: showAuthorizationAlert$)
            .disposed(by: disposeBag)
        
        let startNormalFlow = startFlow
            .filter { $0.authorization != .denied }
            .map { (gps: $0, authorization: $1 == .authorizedWhenInUse) }
            .share()
        
        // 1. Off/Off - 권한 요청 후 승인시 서버에 On 상태 저장
        startNormalFlow
            .filter { !$0 && !$1 }
            .map { _ in }
            .flatMap(dependency.locationRepsitory.requestAuthorization)
            .filter { $0 == .authorizedWhenInUse }
            .map { _ in true }
            .flatMap(dependency.bappyAuthRepository.updateGPSSetting)
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        // 2. On/Off - 권한 요청
        startNormalFlow
            .filter { $0 && !$1 }
            .map { _ in }
            .flatMap(dependency.locationRepsitory.requestAuthorization)
            .bind(onNext: { _ in })
            .disposed(by: disposeBag)
        
        // 3. Off/On - 서버에 On 상태 저장   &&   4. On/On - 서버에 Off 상태 저장
        startNormalFlow
            .filter { $1 }
            .map { !$0.gps }
            .flatMap(dependency.bappyAuthRepository.updateGPSSetting)
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        // 셀 선택 Flow
        let selectResult = itemSelected$
            .withLatestFrom(locations$) { indexPath, locations -> Location in
                return locations[indexPath.row]
            }
            .map { (id: $0.identity, isSelcted: !$0.isSelected) }
            .flatMap(dependency.bappyAuthRepository.selectLocation)
            .share()
        
        selectResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        // 선택 상태 뒤집기
        selectResult
            .compactMap(getValue)
            .withLatestFrom(itemSelected$)
            .withLatestFrom(locations$) { indexPath, locations -> [Location] in
                var locations = locations
                // false -> true 바꾸는 동작, 나머지 다 false
                if !locations[indexPath.row].isSelected {
                    locations = locations.map { location -> Location in
                        var location = location
                        location.isSelected = false
                        return location
                    }
                }
                locations[indexPath.row].isSelected = !locations[indexPath.row].isSelected
                return locations
            }
            .bind(to: locations$)
            .disposed(by: disposeBag)
        
        // 셀 삭제 Flow
        let deleteResult = itemDeleted$
            .withLatestFrom(locations$) { $1[$0.row].identity }
            .flatMap(dependency.bappyAuthRepository.deleteLocation)
            .share()
        
        deleteResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        deleteResult
            .compactMap(getValue)
            .withLatestFrom(itemDeleted$)
            .withLatestFrom(locations$) { indexPath, locations -> [Location] in
                var locations = locations
                locations.remove(at: indexPath.row)
                return locations
            }
            .bind(to: locations$)
            .disposed(by: disposeBag)
    
        // Child
        userGPSWithAuthorization$
            .map { $0.gps && ($0.authorization == .authorizedWhenInUse) }
            .bind(to: subViewModels.headerViewModel.input.isUserUsingGPS)
            .disposed(by: disposeBag)
        
        subViewModels.headerViewModel.output.localeButtonTapped
            .emit(to: localeButtonTapped$)
            .disposed(by: disposeBag)
    }
}
