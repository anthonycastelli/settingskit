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

    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get { return UserDefaults.standard.object(forKey: self.key) as? Value ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
    
    public var projectedValue: Value {
       get { return UserDefaults.standard.object(forKey: self.key) as? Value ?? self.defaultValue }
       set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}

@propertyWrapper
public struct OptionalSetting<Value> {
    let key: String

    public init(_ key: String) {
        self.key = key
    }
    
    public var wrappedValue: Value? {
        get { return UserDefaults.standard.object(forKey: self.key) as? Value }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
    
    public var projectedValue: Value? {
       get { return UserDefaults.standard.object(forKey: self.key) as? Value }
       set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}
