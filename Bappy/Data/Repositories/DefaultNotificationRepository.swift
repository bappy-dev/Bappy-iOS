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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(observeAuthorizationStatus),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc
    private func observeAuthorizationStatus() {
        notificationCenter.getNotificationSettings { [weak self] setting in
            self?.authorization$.onNext(setting.authorizationStatus)
        }
    }
}

extension DefaultNotificationRepository: NotificationRepository {

    static let shared = DefaultNotificationRepository()
    var authorization: BehaviorSubject<UNAuthorizationStatus?> { authorization$ }

    func requestAuthorization(completion: ((Result<UNAuthorizationStatus, Error>) -> Void)?) {
        let options: UNAuthorizationOptions = [.alert, .sound]
        notificationCenter.requestAuthorization(options: options) { [weak self] _, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            self?.notificationCenter.getNotificationSettings { setting in
                let authorization = setting.authorizationStatus
                self?.authorization$.onNext(authorization)
                completion?(.success(authorization))
            }
        }
    }
    
    func requestAuthorization() -> Single<Result<UNAuthorizationStatus, Error>> {
        return Single<Result<UNAuthorizationStatus, Error>>.create { [weak self] single in
            self?.requestAuthorization(completion: { result in
                switch result {
                case .success(let value): single(.success(.success(value)))
                case .failure(let error): single(.success(.failure(error)))
                }
            })
            return Disposables.create()
        }
    }
}
