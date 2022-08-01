//
//  Alertable.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/29.
//

import UIKit
import RxSwift

struct Alert {
    var title: String?
    var message: String?
    var bappyStyle: BappyAlertController.BappyStyle?
    var canCancel: Bool
    var canDismissByTouch: Bool
    var isContentsBlurred: Bool
    var action: Action?
    
    init(title: String? = nil,
         message: String? = nil,
         bappyStyle: BappyAlertController.BappyStyle? = nil,
         canCancel: Bool = false,
         canDismissByTouch: Bool = true,
         isContentsBlurred: Bool = false,
         action: Action? = nil) {
        self.title = title
        self.message = message
        self.bappyStyle = bappyStyle
        self.canCancel = canCancel
        self.canDismissByTouch = canDismissByTouch
        self.isContentsBlurred = isContentsBlurred
        self.action = action
    }
}

extension Alert {
    struct Action {
        var actionTitle: String
        var actionStyle: BappyAlertAction.Style
        var completion: (() -> Void)?
        
        init(actionTitle: String,
             actionStyle: BappyAlertAction.Style = .default,
             completion: (() -> Void)? = nil) {
            self.actionTitle = actionTitle
            self.actionStyle = actionStyle
            self.completion = completion
        }
    }
}

protocol Alertable {}
extension Alertable where Self: UIViewController {
    func showAlert(_ alert: Alert) {
        let alertController = BappyAlertController(
            title: alert.title,
            message: alert.message,
            bappyStyle: alert.bappyStyle)
        alertController.canDismissByTouch = alert.canDismissByTouch
        alertController.isContentsBlurred = alert.isContentsBlurred
        
        if alert.canCancel {
            let cancelAction = BappyAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
        }
        
        if let action = alert.action {
            let alertAction = BappyAlertAction(
                title: action.actionTitle,
                style: action.actionStyle,
                handler: { _ in action.completion?() })
            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: false)
    }
}

extension UIViewController: Alertable {}

extension Reactive where Base: UIViewController {
    var showAlert: Binder<Alert> {
        return Binder(base) { base, alert in
            base.showAlert(alert)
        }
    }
    
    var showSignInAlert: Binder<String> {
        return Binder(base) { base, title in
            let alert = SignInAlertController(title: title)
            base.present(alert, animated: false)
        }
    }
}
