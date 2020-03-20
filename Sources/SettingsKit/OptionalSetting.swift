//
//  OptionalSetting.swift
//  
//
//  Created by Anthony Castelli on 3/20/20.
//

import Foundation

@propertyWrapper
public struct OptionalSetting<Value> {
    let key: String
    let userDefaults: UserDefaults

    public init(_ key: String, in userDefaults: UserDefaults = UserDefaults.standard) {
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
