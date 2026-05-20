import XCTest
@testable import CoveredCollection

final class UserProfileTests: XCTestCase {

    func test_defaultProfile_hasExpectedShape() {
        let profile = UserProfile()
        XCTAssertEqual(profile.firstName, "Amina")
        XCTAssertNil(profile.currentPlan)
        XCTAssertEqual(profile.modestyDNA, .aminaDefault)
        XCTAssertTrue(profile.savedProducts.isEmpty)
        XCTAssertTrue(profile.currentBox.isEmpty)
        XCTAssertTrue(profile.queue.isEmpty)
    }

    func test_codable_roundTrip_preservesEverything() throws {
        var profile = UserProfile()
        profile.firstName = "Layla"
        profile.savedProducts = [UUID(), UUID(), UUID()]
        profile.currentBox = [UUID(), UUID()]
        profile.queue = [UUID()]

        let data = try JSONEncoder().encode(profile)
        let decoded = try JSONDecoder().decode(UserProfile.self, from: data)

        XCTAssertEqual(decoded.firstName, profile.firstName)
        XCTAssertEqual(decoded.savedProducts, profile.savedProducts)
        XCTAssertEqual(decoded.currentBox, profile.currentBox)
        XCTAssertEqual(decoded.queue, profile.queue)
        XCTAssertEqual(decoded.modestyDNA, profile.modestyDNA)
    }

    func test_savedProducts_isASet_dedupesInsertion() {
        var profile = UserProfile()
        let id = UUID()
        profile.savedProducts.insert(id)
        profile.savedProducts.insert(id)
        XCTAssertEqual(profile.savedProducts.count, 1)
    }

    func test_savedProductsMutation_doesNotAffectQueue() {
        var profile = UserProfile()
        profile.savedProducts.insert(UUID())
        XCTAssertTrue(profile.queue.isEmpty)
    }
}
