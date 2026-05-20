import XCTest
@testable import CoveredCollection

final class ModestyDNATests: XCTestCase {

    func test_aminaDefault_hasExpectedValues() {
        let dna = ModestyDNA.aminaDefault
        XCTAssertEqual(dna.neckline, .modestScoop)
        XCTAssertEqual(dna.sleeve, .long)
        XCTAssertEqual(dna.hem, .midi)
        XCTAssertEqual(dna.opacity, .fullyOpaque)
        XCTAssertEqual(dna.silhouette, .relaxed)
        XCTAssertTrue(dna.optionalTags.contains(.hijabFriendly))
    }

    func test_codable_roundTrip_preservesAllAxes() throws {
        let original = ModestyDNA(
            neckline: .high,
            sleeve: .threeQuarter,
            hem: .anklePlus,
            opacity: .linedRequired,
            silhouette: .veryLoose,
            optionalTags: [.hijabFriendly, .abayaWear, .maternity]
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ModestyDNA.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func test_axisDisplayNames_areAllNonEmpty() {
        XCTAssertTrue(Neckline.allCases.allSatisfy { !$0.displayName.isEmpty })
        XCTAssertTrue(SleeveLength.allCases.allSatisfy { !$0.displayName.isEmpty })
        XCTAssertTrue(HemLength.allCases.allSatisfy { !$0.displayName.isEmpty })
        XCTAssertTrue(Opacity.allCases.allSatisfy { !$0.displayName.isEmpty })
        XCTAssertTrue(Silhouette.allCases.allSatisfy { !$0.displayName.isEmpty })
        XCTAssertTrue(ModestyTag.allCases.allSatisfy { !$0.displayName.isEmpty })
        XCTAssertTrue(ModestyTag.allCases.allSatisfy { !$0.symbol.isEmpty })
    }

    func test_matches_returnsTrue_whenProductWithinUserPermissiveness() {
        // User accepts everything up to V-neck. A product with a high neckline must match.
        var user = ModestyDNA.aminaDefault
        user.neckline = .vNeck
        let product = ModestyDNA(
            neckline: .high,
            sleeve: .long,
            hem: .midi,
            opacity: .fullyOpaque,
            silhouette: .relaxed
        )
        XCTAssertTrue(user.matches(product: product))
    }

    func test_matches_returnsFalse_whenProductMorePermissiveThanUser() {
        // User wants high necks only. Product is V-neck — too permissive.
        var user = ModestyDNA.aminaDefault
        user.neckline = .high
        let product = ModestyDNA(
            neckline: .vNeck,
            sleeve: .long,
            hem: .midi,
            opacity: .fullyOpaque,
            silhouette: .relaxed
        )
        XCTAssertFalse(user.matches(product: product))
    }

    func test_matches_isReflexive_forIdenticalDNA() {
        let dna = ModestyDNA.aminaDefault
        XCTAssertTrue(dna.matches(product: dna))
    }

    func test_optionalTags_setSemantics_deduplicate() {
        var dna = ModestyDNA()
        dna.optionalTags.insert(.hijabFriendly)
        dna.optionalTags.insert(.hijabFriendly)
        XCTAssertEqual(dna.optionalTags.count, 1)
    }
}
