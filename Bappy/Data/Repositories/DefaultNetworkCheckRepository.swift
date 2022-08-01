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
        DispatchQueue.main.async {
            if let viewController = UIWindow.keyWindow?.visibleViewConroller {
                let action = Alert.Action(actionTitle: "Retry") { handler?() }
                let alert = Alert(
                    title: "No Internet Connection\n",
                    message: "\nPlease check your internet\nconnection and try again\n",
                    bappyStyle: .sad,
                    canDismissByTouch: false,
                    action: action
                    )
                viewController.showAlert(alert)
            }
        }
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
