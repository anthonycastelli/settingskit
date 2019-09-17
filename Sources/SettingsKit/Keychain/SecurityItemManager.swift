//
//  SecurityItemManager.swift
//
//
//  Created by Anthony Castelli on 9/13/19.
//

import Foundation
import Security

protocol SecurityItemManaging {
    func add(withAttributes attributes: [String: Any], result: UnsafeMutablePointer<CoreFoundation.CFTypeRef?>?) -> OSStatus
    func update(withQuery query: [String: Any], attributesToUpdate: [String: Any]) -> OSStatus
    func delete(withQuery query: [String: Any]) -> OSStatus
    func copyMatching(_ query: [String: Any], result: UnsafeMutablePointer<CoreFoundation.CFTypeRef?>?) -> OSStatus
}

final class SecurityItemManager {
    static let `default` = SecurityItemManager()
}

extension SecurityItemManager: SecurityItemManaging {
    func add(withAttributes attributes: [String: Any], result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        return SecItemAdd(attributes as CFDictionary, result)
    }

    func update(withQuery query: [String: Any], attributesToUpdate: [String: Any]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    }

    func delete(withQuery query: [String : Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }

    func copyMatching(_ query: [String : Any], result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        return SecItemCopyMatching(query as CFDictionary, result)
    }
}
