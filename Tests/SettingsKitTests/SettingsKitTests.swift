import XCTest
@testable import SettingsKit

final class SettingsKitTests: XCTestCase {
    struct ComplexSruct: Codable, Equatable {
        var name: String
    }
    
    struct TestDefaults {
        // Regular Setting
        @Setting("test", defaultValue: "Test Setting")
        var test: String
        
        // Optional Setting
        @OptionalSetting("optional")
        var optionalText: String?
        
        @OptionalSetting("optional_int")
        var optionalInt: Int?
        
        
        // Secure Settings
        @SecureSetting("string_keychain", defaultValue: "A simple keychain test")
        var keychainString: String
        
        @SecureSetting("int_keychain", defaultValue: 10)
        var keychainInt: Int
        
        @SecureSetting("bool_keychain", defaultValue: false)
        var keychainBool: Bool
        
        
        // Complex Setting
        @ComplexSetting("complex_setting")
        var complexSetting: ComplexSruct?
    }
    
    func testSettings() {
        // Clear everything
        UserDefaults.standard.removeObject(forKey: "test")
        UserDefaults.standard.removeObject(forKey: "optional")
        UserDefaults.standard.removeObject(forKey: "optional_int")
        
        // Initialization
        var tester = TestDefaults()
        
        // Test Reading
        XCTAssertEqual(tester.test, "Test Setting")
        XCTAssertEqual(tester.optionalText, nil)
        XCTAssertEqual(tester.optionalInt, nil)
        
        // Test Writing
        tester.test = "Setting to save"
        XCTAssertEqual(tester.test, "Setting to save")
        
        tester.optionalText = "Non-Optional Value"
        XCTAssertEqual(tester.optionalText, "Non-Optional Value")
        
        tester.optionalInt = 100
        XCTAssertEqual(tester.optionalInt, 100)
        
        // Verification
        let rawTest = UserDefaults.standard.string(forKey: "test")
        XCTAssertEqual(tester.test, rawTest)
        
        let rawOptionalString = UserDefaults.standard.string(forKey: "optional")
        XCTAssertEqual(tester.optionalText, rawOptionalString)
        
        let rawOptionalInt = UserDefaults.standard.integer(forKey: "optional_int")
        XCTAssertEqual(tester.optionalInt, rawOptionalInt)
    }
    
    func testKeychain() {
        // Clear Everything
        try? Keychain().clearAll()
        
        // Initialization
        var tester = TestDefaults()
        
        // Test Reading
        XCTAssertEqual(tester.keychainString, "A simple keychain test")
        XCTAssertEqual(tester.keychainInt, 10)
        XCTAssertEqual(tester.keychainBool, false)
        
        // Test Writing
        tester.keychainString = "New string to the keychain"
        XCTAssertEqual(tester.keychainString, "New string to the keychain")
        
        tester.keychainInt = 1_000_000
        XCTAssertEqual(tester.keychainInt, 1_000_000)
        
        tester.keychainBool = true
        XCTAssertEqual(tester.keychainBool, true)
        
        // Verification
        let string: SecureItem<String>? = try? Keychain().retrieveValue(forAccount: "string_keychain")
        XCTAssertEqual(tester.keychainString, string?.value)
        
        let int: SecureItem<Int>? = try? Keychain().retrieveValue(forAccount: "int_keychain")
        XCTAssertEqual(tester.keychainInt, int?.value)
        
        let bool: SecureItem<Bool>? = try? Keychain().retrieveValue(forAccount: "bool_keychain")
        XCTAssertEqual(tester.keychainBool, bool?.value)
    }
    
    func testComplexSetting() {
        // Clear Everything
        UserDefaults.standard.removeObject(forKey: "complex_setting")
        
        // Initialization
        var tester = TestDefaults()
        
        // Test Reading
        XCTAssertEqual(tester.complexSetting, nil)
        
        // Test Writing
        tester.complexSetting = ComplexSruct(name: "Complex Setting")
        XCTAssertEqual(tester.complexSetting?.name, "Complex Setting")
    }
    
    func testWrappers() {
        let tester = TestDefaults()
        XCTAssertEqual(tester.test, tester.$test)
        XCTAssertEqual(tester.optionalText, tester.$optionalText)
        XCTAssertEqual(tester.optionalInt, tester.$optionalInt)
        XCTAssertEqual(tester.keychainString, tester.$keychainString)
        XCTAssertEqual(tester.keychainInt, tester.$keychainInt)
        XCTAssertEqual(tester.keychainBool, tester.$keychainBool)
        XCTAssertEqual(tester.complexSetting, tester.$complexSetting)
    }
    
    static var allTests = [
        ("testSettings", testSettings),
        ("testKeychain", testKeychain),
        ("testComplexSetting", testComplexSetting),
        ("testWrappers", testWrappers),
    ]
}
