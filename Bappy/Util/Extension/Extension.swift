//
//  Extension.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import RxSwift

// MARK: - UIWindow
extension UIWindow {
    static var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
    
    var visibleViewConroller: UIViewController? {
        return self.getVisibleViewConroller(from: self.rootViewController)
    }
    
    func getVisibleViewConroller(from viewController: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationViewController = viewController as? UINavigationController {
            return self.getVisibleViewConroller(from: navigationViewController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return self.getVisibleViewConroller(from: tabBarController.selectedViewController)
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                return self.getVisibleViewConroller(from: presentedViewController)
            } else {
                return viewController
            }
        }
    }
}

// MARK: - UIApplication
extension UIApplication {
    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
    }
}


// MARK: - UINavigationController
extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, transitionType: CATransitionType) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = transitionType
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping() -> Void) {
        pushViewController(viewController, animated: animated)
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: @escaping() -> Void) {
        popViewController(animated: animated)
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

// MARK: - UIFont
extension UIFont {
    enum Family: String {
        case Black, Bold, Light, Medium, Regular, Thin
    }
    
    static func roboto(size: CGFloat, family: Family = .Regular) -> UIFont {
        return UIFont(name: "Roboto-\(family)", size: size)!
    }
}

// MARK: - UIView
extension UIView {
    convenience init(color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
    
    func addBappyShadow(shadowOffsetHeight: CGFloat = 2.0, shouldSetShadowPath: Bool = true) {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: shadowOffsetHeight)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 1.0
        // render 처리 비용이 비싸기 때문에 아래 코드를 추가하고, layer가 확정된 상태에서 이 함수를 호출해야함.
        if shouldSetShadowPath {
            self.layer.shadowPath = UIBezierPath(
                roundedRect: self.bounds,
                cornerRadius: self.layer.cornerRadius
            ).cgPath
        }
    }
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

// MARK: - UIStackView
extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

// MARK: - UIImage
extension UIImage {
    func downSize(newWidth: CGFloat) -> UIImage {
        guard newWidth < self.size.width else { return self }
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}

// MARK: - DATE
extension Date {
    func isSameDate(with date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let orgDate = dateFormatter.string(from: self)
        let otherDate = dateFormatter.string(from: date)
        return orgDate == otherDate
    }
    
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func roundUpUnitDigitOfMinutes() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        var string = dateFormatter.string(from: self + 600)
        _ = string.popLast()
        string.append("0")
        return dateFormatter.date(from: string) ?? Date()
    }
    
    static var thisYear: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 0
    }
}

// MARK: - String
extension String {
    func isValidDateType(format: String = "yyyy-MM-dd") -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) != nil
    }
    
    func toFlag() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func toAnotherDateFormat(from beforeDateFormat: String,
                             to afterDateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = beforeDateFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = afterDateFormat
        return date.flatMap { dateFormatter.string(from: $0) }
    }
}

// MARK: - UITableView
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, with cellType: T.Type = T.self) -> T {
        let identifier = "\(cellType)"
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a view with identifier \(identifier) matching type \(cellType.self).")
        }
        
        return cell
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, with cellType: T.Type = T.self) -> T {
        let identifier = "\(cellType)"
        guard let  cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a view with identifier \(identifier) matching type \(cellType.self).")
        }
        
        return cell
    }
}

// MARK: - UILabel
extension UILabel {
    static func getSize(_ text: String) -> CGRect {
        let lbl = UILabel()
        lbl.text = text
        lbl.frame.size = lbl.intrinsicContentSize
        return lbl.frame
    }
}

// MARK: - UIResponder
extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

// MARK: - UIButton
extension UIButton {
    func setBappyTitle(title: String,
                       font: UIFont = .roboto(size: 16.0, family: .Regular),
                       color: UIColor = .bappyBrown,
                       hasUnderline: Bool = false,
                       isSelected: Bool = false) {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        
        if hasUnderline {
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .underlineStyle)
            self.tintColor = color
        }
        
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        if isSelected {
            self.setAttributedTitle(attributedString, for: .selected)
        } else {
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

// MARK: - UIColor
extension UIColor {
    static var bappyYellow: UIColor { UIColor(named: "bappy_yellow") ?? .clear }
    static var bappyBrown: UIColor { UIColor(named: "bappy_brown") ?? .clear }
    static var bappyGray: UIColor { UIColor(named: "bappy_gray") ?? .clear }
    static var bappyLightgray: UIColor { UIColor(named: "bappy_lightgray") ?? .clear }
    static var bappyCoral: UIColor { UIColor(named: "bappy_coral") ?? .clear }
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: Double) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}

// MARK: - NSAttributedString
extension NSAttributedString {
    convenience init(stringList: [String],
                     bullet: String = "\u{2022}",
                     font: UIFont = .systemFont(ofSize: 16.0),
                     textColor: UIColor = .label,
                     indentation: CGFloat = .zero,
                     lineSpacing: CGFloat = .zero,
                     paragraphSpacing: CGFloat = .zero) {
        let paragraphStyle = NSMutableParagraphStyle()
        let tabStopOptions: [NSTextTab.OptionKey: Any] = [:]
        
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: tabStopOptions)
        ]
        
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            let attributedStringRange = NSMakeRange(0, attributedString.length)
            attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: attributedStringRange)
            attributedString.addAttributes([.foregroundColor: textColor], range: attributedStringRange)
            attributedString.addAttributes([.font: font], range: attributedStringRange)
            
            bulletList.append(attributedString)
        }
        
        self.init(attributedString: bulletList)
    }
}
