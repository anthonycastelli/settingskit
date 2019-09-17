//
//  File.swift
//  
//
//  Created by Anthony Castelli on 9/16/19.
//

import Foundation

@propertyWrapper
public struct SecureSetting<Value> where Value: Codable {
    let key: String
    let defaultValue: Value

    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get {
            let keychain = Keychain()
            let value: SecureItem<Value>? = try! keychain.retrieveValue(forAccount: self.key)
            return value?.value ?? self.defaultValue
        }
        set {
            let keychain = Keychain()
            try! keychain.store(SecureItem<Value>(key: self.key, value: newValue), key: self.key)
        }
    }
    
    public var projectedValue: Value {
       get {
           let keychain = Keychain()
           let value: SecureItem<Value>? = try! keychain.retrieveValue(forAccount: self.key)
           return value?.value ?? self.defaultValue
       }
       set {
           let keychain = Keychain()
           try! keychain.store(SecureItem<Value>(key: self.key, value: newValue), key: self.key)
       }
    }
}

struct SecureItem<Value: Codable>: KeychainStorable {
    var account: String
    let value: Value
    
    init(key: String, value: Value) {
        self.account = key
        self.value = value
    }
}
