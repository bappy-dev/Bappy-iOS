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
    func addBappyShadow(shadowOffsetHeight: CGFloat = 2.0) {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: shadowOffsetHeight)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 1.0
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

// MARK: - UIButton
extension UIButton {
    func setBappyTitle(title: String,
                       font: UIFont = .roboto(size: 16.0, family: .Regular),
                       color: UIColor = .bappyBrown,
                       hasUnderline: Bool = false) {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        
        if hasUnderline {
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .underlineStyle)
            self.tintColor = color
        }
        
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

// MARK: - UIColor
extension UIColor {
    static var bappyYellow: UIColor { UIColor(named: "bappy_yellow") ?? .clear }
    static var bappyBrown: UIColor { UIColor(named: "bappy_brown") ?? .clear }
    static var bappyGray: UIColor { UIColor(named: "bappy_gray") ?? .clear }
    static var bappyLightgray: UIColor { UIColor(named: "bappy_lightgray") ?? .clear }
    static var bappyCoral: UIColor { UIColor(named: "bappy_coral") ?? .clear }
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
