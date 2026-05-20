import XCTest
@testable import CoveredCollection

final class MockDataTests: XCTestCase {

    func test_products_haveExpectedCount() {
        XCTAssertEqual(MockData.products.count, 24, "POC ships with 24 mock products")
    }

    func test_products_haveUniqueIDs() {
        let ids = MockData.products.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "Every mock product UUID must be unique")
    }

    func test_products_havePositivePrices() {
        for product in MockData.products {
            XCTAssertGreaterThan(product.priceRetail, 0)
            XCTAssertGreaterThan(product.priceBuyDiscount, 0)
            XCTAssertLessThanOrEqual(product.priceBuyDiscount, product.priceRetail,
                                     "Discount price must not exceed retail price for \(product.name)")
        }
    }

    func test_products_haveNonEmptyName() {
        for product in MockData.products {
            XCTAssertFalse(product.name.isEmpty, "Product name must not be empty")
            XCTAssertFalse(product.brand.isEmpty, "Product brand must not be empty")
        }
    }

    func test_products_haveAtLeastOneAvailableSize() {
        for product in MockData.products {
            XCTAssertFalse(product.availableSizes.isEmpty, "\(product.name) must have at least one size")
        }
    }

    func test_plans_haveExpectedShape() {
        XCTAssertEqual(MockData.plans.count, 3, "POC ships with 3 subscription plans")
        for plan in MockData.plans {
            XCTAssertFalse(plan.name.isEmpty)
            XCTAssertGreaterThan(plan.pricePerMonth, 0)
        }
    }

    func test_events_areSortable() {
        let dates = MockData.events.map(\.date)
        XCTAssertFalse(dates.isEmpty, "Calendar must seed at least one event")
        let sorted = dates.sorted()
        XCTAssertEqual(sorted.count, dates.count)
    }
}
