//
//  Keychain.swift
//
//
//  Created by Anthony Castelli on 9/13/19.
//

import Foundation
import Security

public final class Keychain {
    public enum AccessError: Error {
        case invalidAccountRetrievalResult
        case invalidQueryResult
    }

    private enum Constants {
        static let accessible = kSecAttrAccessible.stringValue
        static let accessGroup = kSecAttrAccessGroup.stringValue
        static let account = kSecAttrAccount.stringValue
        static let `class` = kSecClass.stringValue
        static let matchLimit = kSecMatchLimit.stringValue
        static let returnData = kSecReturnData.stringValue
        static let returnAttributes = kSecReturnAttributes.stringValue
        static let service = kSecAttrService.stringValue
        static let valueData = kSecValueData.stringValue
        static let genericPassword = kSecClassGenericPassword.stringValue
        static let matchLimitOne = kSecMatchLimitOne.stringValue
        static let matchLimitAll = kSecMatchLimitAll.stringValue
    }

    static var defaultIdentifier: String = Bundle.main.infoDictionary?[kCFBundleIdentifierKey.stringValue] as? String ?? "com.anthony.SettingsKit.Keychain"
    
    public private(set) static var defaultService: String = defaultIdentifier
    public private(set) static var defaultAccessGroup: String? = nil

    public static let `default` = Keychain()

    let securityItemManager: SecurityItemManaging

    init(securityItemManager: SecurityItemManaging = SecurityItemManager.default) {
        self.securityItemManager = securityItemManager
    }

    // MARK: Public

    public static func configureDefaults(withService service: String = defaultService, accessGroup: String? = defaultAccessGroup) {
        self.defaultService = service
        self.defaultAccessGroup = accessGroup
    }

    public static func resetDefaults() {
        self.defaultService = self.defaultIdentifier
        self.defaultAccessGroup = nil
    }
    
    public func store<T: KeychainStorable>(_ storable: T, key: String? = nil, service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws {
        let newData = try JSONEncoder().encode(storable)
        var query = self.query(forAccount: key ?? storable.account, service: service, accessGroup: accessGroup)
        let existingData = try self.data(forAccount: key ?? storable.account, service: service, accessGroup: accessGroup)
        var status = noErr
        let newAttributes: [String: Any] = [Constants.valueData: newData, Constants.accessible: storable.accessible.rawValue]
        if existingData != nil {
            try self.data(forAccount: key ?? storable.account, service: service, accessGroup: accessGroup)
            status = self.securityItemManager.update(withQuery: query, attributesToUpdate: newAttributes)
        } else {
            query.merge(newAttributes) { $1 }
            status = self.securityItemManager.add(withAttributes: query, result: nil)
        }
        if let error = self.error(fromStatus: status) {
            throw error
        }
    }

    public func retrieveValue<T: KeychainStorable>(forAccount account: String, service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws -> T? {
        guard let data = try self.data(forAccount: account, service: service, accessGroup: accessGroup) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func retrieveAccounts(withService service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws -> [String] {
        var query = self.query(forAccount: nil, service: service, accessGroup: accessGroup)
        query[Constants.matchLimit] = Constants.matchLimitAll
        query[Constants.returnAttributes] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            self.securityItemManager.copyMatching(query, result: UnsafeMutablePointer($0))
        }
        if let error = self.error(fromStatus: status), error != .itemNotFound { throw error }
        guard result != nil else { return [] }
        guard let attributes = result as? [[String: Any]] else { throw AccessError.invalidAccountRetrievalResult }
        return attributes.compactMap { $0[Constants.account] as? String }
    }

    public func delete<T: KeychainStorable>(_ storable: T, key: String? = nil, service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws {
        let query = self.query(forAccount: key ?? storable.account, service: service, accessGroup: accessGroup)
        let status = self.securityItemManager.delete(withQuery: query)
        if let error = self.error(fromStatus: status) { throw error }
    }

    public func clearAll(withService service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws {
        let retrievedAccounts = try self.retrieveAccounts(withService: service, accessGroup: accessGroup)
        try retrievedAccounts.forEach {
            let query = self.query(forAccount: $0, service: service, accessGroup: accessGroup)
            try self.delete(withQuery: query)
        }
    }

    // MARK: Convenience

    func delete(withQuery query: [String: Any]) throws {
        let status = self.securityItemManager.delete(withQuery: query)
        if let error = self.error(fromStatus: status) { throw error }
    }

    // MARK: Query

    func query(forAccount account: String?, service: String, accessGroup: String?) -> [String: Any] {
        var query: [String: Any] = [
            Constants.service: service,
            Constants.class: Constants.genericPassword
        ]
        if let account = account {
            query[Constants.account] = account
        }
        if let accessGroup = accessGroup {
            query[Constants.accessGroup] = accessGroup
        }
        return query
    }

    func query(for storable: KeychainStorable, service: String, accessGroup: String?) -> [String: Any] {
        var query = self.query(forAccount: storable.account, service: service, accessGroup: accessGroup)
        query[Constants.accessible] = storable.accessible.rawValue
        return query
    }

    // MARK: Data

    @discardableResult
    func data(forAccount account: String, service: String, accessGroup: String?) throws -> Data? {
        var query = self.query(forAccount: account, service: service, accessGroup: accessGroup)
        query[Constants.matchLimit] = Constants.matchLimitOne
        query[Constants.returnData] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            self.securityItemManager.copyMatching(query, result: UnsafeMutablePointer($0))
        }
        if let error = self.error(fromStatus: status), error != .itemNotFound  { throw error }
        guard result != nil else { return nil }
        guard let resultData = result as? Data else { throw AccessError.invalidQueryResult }
        return resultData
    }

    // MARK: Error

    func error(fromStatus status: OSStatus) -> KeychainError? {
        guard status != noErr && status != errSecSuccess else { return nil }
        return KeychainError(rawValue: Int(status)) ?? .unknown
    }
}
