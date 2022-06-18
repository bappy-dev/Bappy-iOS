//
//  RxExtension.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    var setContentOffset: Binder<CGPoint> {
        return Binder(self.base) { scrollView, offset in
            scrollView.setContentOffset(offset, animated: true)
        }
    }
}

extension Reactive where Base: UIView {
    var endEditing: Binder<Void> {
        return Binder(self.base) { view, _ in
            view.endEditing(true)
        }
    }
}

extension Reactive where Base: UIViewController {
    var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    var showProgress: Binder<Bool> {
        return Binder(self.base) { view, isUserInteractionEnabled in
            ProgressHUD.show(interaction: isUserInteractionEnabled)
        }
    }
    
    var dismissProgress: Binder<Void> {
        return Binder(self.base) { view, _ in
            ProgressHUD.dismiss()
        }
    }
}

extension Reactive where Base: UIDatePicker {
    var resignFirstResponder: Binder<Void> {
        return Binder(self.base) { datePicker, _ in
            _ = datePicker.resignFirstResponder()
        }
    }
}

extension Reactive where Base: ProgressHUD {
    public static var show: Binder<Bool> {
        return Binder(UIApplication.shared) { _, interaction in
            ProgressHUD.show(interaction: interaction)
        }
    }
    
    public static var dismiss: Binder<Void> {
        return Binder(UIApplication.shared) { _, _ in
            ProgressHUD.dismiss()
        }
    }
}
