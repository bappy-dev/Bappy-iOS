//
//  DefaultNetworkCheckRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/29.
//

import UIKit
import Network
import RxSwift

final class DefaultNetworkCheckRepository {
    
    private let disposeBag = DisposeBag()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var connection: Bool = false
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    private func showNetworkAlert(handler: (() -> Void)? = nil) {
        let alertView = NoInternetConnectionView()
        alertView.show { handler?() }
    }
}

extension DefaultNetworkCheckRepository: NetworkCheckRepository {

    static let shared = DefaultNetworkCheckRepository()
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("DEBUG: isConnected \(path.status == .satisfied) \(path.status)")
            self?.connection = (path.status == .satisfied)
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
    func checkNetworkConnection(completion: @escaping() -> Void) {
        if connection {
            completion()
        } else {
            showNetworkAlert { [weak self] in
                self?.checkNetworkConnection(completion: completion)
            }
        }
    }
}
