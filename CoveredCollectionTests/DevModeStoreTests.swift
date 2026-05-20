import XCTest
@testable import CoveredCollection

final class DevModeStoreTests: XCTestCase {

    private var store: DevModeStore!

    override func setUp() {
        super.setUp()
        store = DevModeStore()
        store.isEnabled = false
    }

    override func tearDown() {
        store.isEnabled = false
        super.tearDown()
    }

    func test_authenticate_withValidCredentials_returnsTrue() {
        XCTAssertTrue(store.authenticate(username: "dev", password: "Nanoose2!"))
    }

    func test_authenticate_withWrongUsername_returnsFalse() {
        XCTAssertFalse(store.authenticate(username: "Dev", password: "Nanoose2!"))
        XCTAssertFalse(store.authenticate(username: "admin", password: "Nanoose2!"))
        XCTAssertFalse(store.authenticate(username: "", password: "Nanoose2!"))
    }

    func test_authenticate_withWrongPassword_returnsFalse() {
        XCTAssertFalse(store.authenticate(username: "dev", password: "nanoose2!"))
        XCTAssertFalse(store.authenticate(username: "dev", password: "Nanoose2"))
        XCTAssertFalse(store.authenticate(username: "dev", password: ""))
    }

    func test_authenticate_doesNotChangeEnabledState() {
        XCTAssertFalse(store.isEnabled)
        _ = store.authenticate(username: "dev", password: "Nanoose2!")
        XCTAssertFalse(store.isEnabled, "authenticate() must not flip isEnabled — the caller does that")
    }

    func test_logout_disablesDevMode() {
        store.isEnabled = true
        store.logout()
        XCTAssertFalse(store.isEnabled)
    }

    func test_isEnabled_persistsToUserDefaults() {
        store.isEnabled = true
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "devModeEnabled"))
        store.isEnabled = false
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "devModeEnabled"))
    }
}
