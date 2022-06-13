//
//  Extension.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import RxSwift

extension UIFont {
    enum Family: String {
        case Black, Bold, Light, Medium, Regular, Thin
    }
    
    static func roboto(size: CGFloat, family: Family = .Regular) -> UIFont {
        return UIFont(name: "Roboto-\(family)", size: size)!
    }
}

extension UIView {
    func addBappyShadow(shadowOffsetHeight: CGFloat = 2.0) {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: shadowOffsetHeight)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 1.0
    }
}

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
}

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
}
