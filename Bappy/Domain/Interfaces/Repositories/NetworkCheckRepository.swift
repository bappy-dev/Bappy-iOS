//
//  NetworkCheckRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/29.
//

import Foundation
import RxSwift

protocol NetworkCheckRepository {
    static var shared: Self { get }
    func startMonitoring()
    func stopMonitoring()
    func checkNetworkConnection(completion: @escaping() -> Void)
}

extension NetworkCheckRepository {
    func checkNetworkConnection() -> Observable<Void> {
        return Observable<Void>.create { observer in
            checkNetworkConnection {
                observer.onNext(Void())
            }
            return Disposables.create()
        }
    }
}
