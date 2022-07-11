//
//  DefaultLocationRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/10.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class DefaultLocationRepository {

    private let disposeBag = DisposeBag()
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }()

    private let location$ = BehaviorSubject<CLLocationCoordinate2D?>(value: nil)
    private let status$: BehaviorSubject<CLAuthorizationStatus>

    private init() {
        self.locationManager.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate }
            .bind(onNext: self.location$.onNext)
            .disposed(by: disposeBag)
        let authorizationStatus = locationManager.authorizationStatus
        self.status$ = BehaviorSubject<CLAuthorizationStatus>(value: authorizationStatus)
    }
}

extension DefaultLocationRepository: LocationRepository {

    static let shared = DefaultLocationRepository()
    var location: BehaviorSubject<CLLocationCoordinate2D?> { location$ }
    var status: BehaviorSubject<CLAuthorizationStatus> { status$ }

    func requestLocation() -> Observable<CLAuthorizationStatus> {
        return Observable<CLAuthorizationStatus>
            .deferred { [weak self] in
                guard let auth = self else { return .empty() }
                auth.locationManager.requestWhenInUseAuthorization()
                return auth.locationManager.rx.didChangeAuthorizationStatus
                    .filter { $0 != .notDetermined }
                    .do { _ in auth.locationManager.startUpdatingLocation() }
                    .take(1)
            }
    }
    
    func turnOnGPS() {
        self.locationManager.startUpdatingLocation()
    }
    
    func turnOffGPS() {
        self.locationManager.stopUpdatingLocation()
    }
}
