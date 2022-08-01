//
//  RxExtension.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa
import YPImagePicker

extension Reactive where Base: UIScrollView {
    var setContentOffset: Binder<CGPoint> {
        return Binder(self.base) { scrollView, offset in
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    var scrollToTop: Binder<Void> {
        return Binder(self.base) { scrollView, _ in
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

extension Reactive where Base: UITableView {
    var setEditing: Binder<Bool> {
        return Binder(self.base) { tableView, editing in
            tableView.setEditing(editing, animated: true)
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
    var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    var viewWillLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillLayoutSubviews))
            .map { _ in }
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

extension Reactive where Base: UIActivityIndicatorView {
    var shouldAnimate: Binder<Bool> {
        return Binder(self.base) { spinner, animate in
            if animate { spinner.startAnimating() }
            else { spinner.stopAnimating() }
        }
    }
}

extension Reactive where Base: ProgressHUD {
    public static var showTranscluentLoader: Binder<Bool> {
        return Binder(UIApplication.shared) { _, show in
            if show {
                ProgressHUD.animationType = .horizontalCirclesPulse
                ProgressHUD.colorBackground = .black.withAlphaComponent(0.1)
                ProgressHUD.colorAnimation = .bappyBrown
                ProgressHUD.show(interaction: false)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    public static var showYellowLoader: Binder<Bool> {
        return Binder(UIApplication.shared) { _, show in
            if show {
                ProgressHUD.animationType = .horizontalCirclesPulse
                ProgressHUD.colorBackground = .bappyYellow
                ProgressHUD.colorAnimation = .bappyBrown
                ProgressHUD.show(interaction: false)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
}

extension YPImagePicker {
    public var didFinishPicking: Observable<(items: [YPMediaItem], cancelled: Bool)>  {
        return Observable<(items: [YPMediaItem], cancelled: Bool)>.create { [weak self] observer in
            self?.didFinishPicking { items, cancelled in
                observer.onNext((items: items, cancelled: cancelled))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
