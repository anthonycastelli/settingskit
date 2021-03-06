//
//  Setting.swift
//  
//
//  Created by Anthony Castelli on 9/13/19.
//

import Foundation

@propertyWrapper
public struct Setting<Value> {
    let key: String
    let defaultValue: Value
    let userDefaults: UserDefaults

    public init(_ key: String, defaultValue: Value, in userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: Value {
        get {
            return self.userDefaults.object(forKey: self.key) as? Value ?? self.defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                self.userDefaults.removeObject(forKey: self.key)
            } else {
                self.userDefaults.set(newValue, forKey: self.key)
            }
        }
    }
    
    public var projectedValue: Value {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
}

public extension Setting where Value: ExpressibleByNilLiteral {
    init(_ key: String, userDefaults: UserDefaults = .standard) {
        self.init(key, defaultValue: nil, in: userDefaults)
    }
}
