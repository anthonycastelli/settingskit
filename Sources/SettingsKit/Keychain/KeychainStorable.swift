//
//  KeychainStorable.swift
//
//
//  Created by Anthony Castelli on 9/13/19.
//

public protocol KeychainStorable: Codable {
    var account: String { get }
    var accessible: Keychain.AccessibleOption { get }
}

public extension KeychainStorable {
    var accessible: Keychain.AccessibleOption { return .whenUnlocked }
}
