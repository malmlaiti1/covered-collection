import XCTest
@testable import CoveredCollection

final class CancellationReasonTests: XCTestCase {

    func test_allCases_haveExpectedCount() {
        XCTAssertEqual(CancellationReason.allCases.count, 5)
    }

    func test_allCases_haveUniqueRawValues() {
        let rawValues = CancellationReason.allCases.map(\.rawValue)
        XCTAssertEqual(Set(rawValues).count, rawValues.count)
    }

    func test_id_matchesRawValue() {
        for reason in CancellationReason.allCases {
            XCTAssertEqual(reason.id, reason.rawValue)
        }
    }

    func test_codable_roundTrip() throws {
        for reason in CancellationReason.allCases {
            let data = try JSONEncoder().encode(reason)
            let decoded = try JSONDecoder().decode(CancellationReason.self, from: data)
            XCTAssertEqual(decoded, reason)
        }
    }
}

final class SubscriptionStatusTests: XCTestCase {

    func test_allStatuses_codableRoundTrip() throws {
        for status in [SubscriptionStatus.active, .paused, .cancelled] {
            let data = try JSONEncoder().encode(status)
            let decoded = try JSONDecoder().decode(SubscriptionStatus.self, from: data)
            XCTAssertEqual(decoded, status)
        }
    }

    func test_counterOffer_equality() {
        XCTAssertEqual(CounterOffer.discountedMonth(price: 59), .discountedMonth(price: 59))
        XCTAssertNotEqual(CounterOffer.pause(days: 30), .pause(days: 60))
        XCTAssertEqual(CounterOffer.downgradeToCore, .downgradeToCore)
    }
}
