//
//  ComplexSetting.swift
//  
//
//  Created by Anthony Castelli on 3/20/20.
//

import Foundation

@propertyWrapper
public struct ComplexSetting<Value> where Value: Codable {
    let key: String
    let userDefaults: UserDefaults
    
    public init(_ key: String, in userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: Value? {
        get {
            guard let data = self.userDefaults.data(forKey: self.key) else { return nil }
            return try? JSONDecoder().decode(Value.self, from: data)
        }
        set {
            guard let object = newValue else { return }
            let data = try? JSONEncoder().encode(object)
            self.userDefaults.set(data, forKey: self.key)
        }
    }
    
    public var projectedValue: Value? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
}
