//
//  OptionalSetting.swift
//  
//
//  Created by Anthony Castelli on 3/20/20.
//

import Foundation

@available(*, deprecated, message: "Use the @Setting property wrapper now instead. @Setting supports both Optional and Non-Optional values. This will be removed in a future version")
@propertyWrapper
public struct OptionalSetting<Value> {
    let key: String
    let userDefaults: UserDefaults

    public init(_ key: String, in userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: Value? {
        get { return self.userDefaults.object(forKey: self.key) as? Value }
        set { self.userDefaults.set(newValue, forKey: self.key) }
    }
    
    public var projectedValue: Value? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
}
