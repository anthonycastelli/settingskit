//
//  File.swift
//  
//
//  Created by Anthony Castelli on 9/16/19.
//

import Foundation

@propertyWrapper
public struct SecureSetting<Value> where Value: KeychainStorable {
    let key: String
    let defaultValue: Value

    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get { return try! Keychain().retrieveValue(forAccount: self.key) ?? self.defaultValue }
        set { try? Keychain().store(newValue, key: self.key) }
    }
    
    public var projectedValue: Value {
       get { return try! Keychain().retrieveValue(forAccount: self.key) ?? self.defaultValue }
       set { try? Keychain().store(newValue, key: self.key) }
    }
}
