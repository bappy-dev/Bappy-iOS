//
//  LocationRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/10.
//

import Foundation
import RxSwift
import CoreLocation

protocol LocationRepository {
    static var shared: Self { get }
    var location: BehaviorSubject<CLLocationCoordinate2D?> { get }
    var status: BehaviorSubject<CLAuthorizationStatus> { get }
    func requestAuthorization() -> Observable<CLAuthorizationStatus>
    func turnGPSSetting(to setting: Bool)
}
