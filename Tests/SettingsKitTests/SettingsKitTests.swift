import XCTest
@testable import SettingsKit

final class SettingsKitTests: XCTestCase {
    struct TestDefaults {
        @Setting("test", defaultValue: "Test Setting")
        var test: String
        
        @SecureSetting("string_keychain", defaultValue: "A simple keychain test")
        var keychainString: String
        
        @SecureSetting("int_keychain", defaultValue: 10)
        var keychainInt: Int
        
        @SecureSetting("bool_keychain", defaultValue: false)
        var keychainBool: Bool
    }
    
    func testUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "test")
        
        var tester = TestDefaults()
        XCTAssertEqual(tester.test, "Test Setting")
        
        tester.test = "Setting to save"
        XCTAssertEqual(tester.test, "Setting to save")
        
        let savedString = UserDefaults.standard.string(forKey: "test")
        XCTAssertEqual(tester.test, savedString)
    }
    
    func testStringKeychain() {
        try? Keychain().clearAll()
        
        var tester = TestDefaults()
        XCTAssertEqual(tester.keychainString, "A simple keychain test")
        
        tester.keychainString = "New string to the keychain"
        XCTAssertEqual(tester.keychainString, "New string to the keychain")
        
        let value: SecureItem<String>? = try? Keychain().retrieveValue(forAccount: "string_keychain")
        XCTAssertEqual(tester.keychainString, value?.value)
    }

    func testIntKeychain() {
        try? Keychain().clearAll()
        
        var tester = TestDefaults()
        XCTAssertEqual(tester.keychainInt, 10)
        
        tester.keychainInt = 1_000_000
        XCTAssertEqual(tester.keychainInt, 1_000_000)
        
        let value: SecureItem<Int>? = try? Keychain().retrieveValue(forAccount: "int_keychain")
        XCTAssertEqual(tester.keychainInt, value?.value)
    }
    
    func testBoolKeychain() {
        try? Keychain().clearAll()
        
        var tester = TestDefaults()
        XCTAssertEqual(tester.keychainBool, false)
        
        tester.keychainBool = true
        XCTAssertEqual(tester.keychainBool, true)
        
        let value: SecureItem<Bool>? = try? Keychain().retrieveValue(forAccount: "bool_keychain")
        XCTAssertEqual(tester.keychainBool, value?.value)
    }
    
    static var allTests = [
        ("testUserDefaults", testUserDefaults),
        ("testStringKeychain", testStringKeychain),
        ("testIntKeychain", testIntKeychain),
        ("testBoolKeychain", testBoolKeychain)
    ]
}
