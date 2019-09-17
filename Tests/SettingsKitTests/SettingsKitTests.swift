import XCTest
@testable import SettingsKit

final class SettingsKitTests: XCTestCase {
    struct TestDefaults {
        @Setting("test", defaultValue: "Test Setting")
        var test: String
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

    static var allTests = [
        ("testUserDefaults", testUserDefaults),
    ]
}
