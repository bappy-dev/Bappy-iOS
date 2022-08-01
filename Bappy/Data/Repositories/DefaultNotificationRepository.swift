//
//  DefaultNotificationRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/19.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultNotificationRepository {

    private let disposeBag = DisposeBag()
    private let notificationCenter: UNUserNotificationCenter

    private let authorization$ = BehaviorSubject<UNAuthorizationStatus?>(value: nil)

    private init() {
        self.notificationCenter = UNUserNotificationCenter.current()
    }
}

extension DefaultNotificationRepository: NotificationRepository {

    static let shared = DefaultNotificationRepository()
    var authorization: BehaviorSubject<UNAuthorizationStatus?> { authorization$ }

    func requestAuthorization(options: UNAuthorizationOptions) {
        notificationCenter.requestAuthorization(options: options) { [weak self] _, _ in
            self?.notificationCenter.getNotificationSettings { setting in
                self?.authorization$.onNext(setting.authorizationStatus)
            }
        }
    }
}
