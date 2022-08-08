//
//  DefaultLocationRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/10.
//

import Foundation
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

    private let location$ = BehaviorSubject<Coordinates?>(value: nil)
    private let authorization$: BehaviorSubject<CLAuthorizationStatus>

    private init() {
        self.locationManager.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate }
            .map { Coordinates(latitude: $0.latitude, longitude: $0.longitude) }
            .bind(onNext: self.location$.onNext)
            .disposed(by: disposeBag)
        let authorizationStatus = locationManager.authorizationStatus
        self.authorization$ = BehaviorSubject<CLAuthorizationStatus>(value: authorizationStatus)
        
        locationManager.rx.didChangeAuthorizationStatus
            .bind(to: authorization$)
            .disposed(by: disposeBag)
    }
}

extension DefaultLocationRepository: LocationRepository {

    static let shared = DefaultLocationRepository()
    var location: BehaviorSubject<Coordinates?> { location$ }
    var authorization: BehaviorSubject<CLAuthorizationStatus> { authorization$ }

    func requestAuthorization() -> Observable<CLAuthorizationStatus> {
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
    
    func turnGPSSetting(to setting: Bool) {
        if setting { self.locationManager.startUpdatingLocation() }
        else { self.locationManager.stopUpdatingLocation() }
    }
}
