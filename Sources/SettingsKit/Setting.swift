//
//  Setting.swift
//  
//
//  Created by Anthony Castelli on 9/13/19.
//

import Foundation

@propertyWrapper
public struct Setting<T> {
    let key: String
    let defaultValue: T
    let type: SettingType

    public init(_ key: String, defaultValue: T, type: SettingType = .userDefaults) {
        self.key = key
        self.defaultValue = defaultValue
        self.type = type
    }

    public var value: T {
        get {
            return UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
}
