//
//  NotificationRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/19.
//

import Foundation
import RxSwift
import UserNotifications

protocol NotificationRepository {
    static var shared: Self { get }
    var authorization: BehaviorSubject<UNAuthorizationStatus?> { get }
    func requestAuthorization(options: UNAuthorizationOptions)
}
