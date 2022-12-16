//
//  Logger.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/25.
//

import Foundation
import FirebaseAnalytics

protocol EventLoggerProvider {
    func logEvent(_ eventName: String, parameters: [String: Any]?)
    func setUserProperty(value: String?, for name: String)
}

class EventLogger {
    static private var providers: [EventLoggerProvider] = []
    static func setProviders(_ providers: [EventLoggerProvider]) {
        self.providers.append(contentsOf: providers)
    }
    
    static func setProvider(_ provider: EventLoggerProvider) {
        self.providers.append(provider)
    }
    
    static func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        self.providers.forEach { $0.logEvent(eventName, parameters: parameters)}
    }
    
    static func setUserProperty(value: String?, for name: String) {
        self.providers.forEach { $0.setUserProperty(value: value, for: name)}
    }
}

class FBAnalytics: EventLoggerProvider {
    func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        print("log", eventName, parameters ?? "")
        Analytics.logEvent(eventName, parameters: parameters)
    }
    func setUserProperty(value: String?, for name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
}
