import Foundation

enum MockData {

    // MARK: - Helpers

    private static func uuid(_ seed: String) -> UUID {
        // Deterministic UUID derived from a seed string so previews stay stable.
        var bytes = Array(seed.utf8)
        while bytes.count < 16 { bytes.append(0) }
        let trimmed = Array(bytes.prefix(16))
        return UUID(uuid: (
            trimmed[0], trimmed[1], trimmed[2], trimmed[3],
            trimmed[4], trimmed[5], trimmed[6], trimmed[7],
            trimmed[8], trimmed[9], trimmed[10], trimmed[11],
            trimmed[12], trimmed[13], trimmed[14], trimmed[15]
        ))
    }

    private static func date(_ y: Int, _ m: Int, _ d: Int) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: y, month: m, day: d))!
    }

    // MARK: - Subscription Plans

    static let modestEditPlan = SubscriptionPlan(
        id: uuid("plan-modest-edit"),
        name: "Modest Edit",
        pricePerMonth: 89,
        itemsPerMonth: 3,
        isUnlimited: false,
        tagline: "A curated capsule, monthly.",
        features: [
            "3 pieces per month",
            "Free return shipping",
            "PERC-free cleaning",
            "Cancel anytime"
        ],
        isFeatured: false
    )

    static let signaturePlan = SubscriptionPlan(
        id: uuid("plan-signature"),
        name: "Signature",
        pricePerMonth: 129,
        itemsPerMonth: 5,
        isUnlimited: false,
        tagline: "Our most-loved rotation.",
        features: [
            "5 pieces per month",
            "Priority access to new arrivals",
            "1 free swap mid-month",
            "Free return shipping",
            "PERC-free cleaning"
        ],
        isFeatured: true
    )

    static let unlimitedPlan = SubscriptionPlan(
        id: uuid("plan-unlimited"),
        name: "Unlimited Closet",
        pricePerMonth: 169,
        itemsPerMonth: nil,
        isUnlimited: true,
        tagline: "Wear, return, repeat — as often as you like.",
        features: [
            "Unlimited swaps",
            "Concierge styling",
            "Same-week reshipments",
            "Free return shipping",
            "PERC-free cleaning"
        ],
        isFeatured: false
    )

    static let plans: [SubscriptionPlan] = [modestEditPlan, signaturePlan, unlimitedPlan]

    // MARK: - Calendar events (anchored to 2027 — far enough ahead from 2026-05 to stay future)

    static let events: [CalendarEvent] = [
        CalendarEvent(
            id: uuid("evt-ramadan-2027"),
            name: "Ramadan begins",
            date: date(2027, 2, 17),
            category: .religious,
            recommendedEditName: "Ramadan 2027 Collection"
        ),
        CalendarEvent(
            id: uuid("evt-eid-fitr-2027"),
            name: "Eid al-Fitr",
            date: date(2027, 3, 18),
            category: .religious,
            recommendedEditName: "Eid Ready"
        ),
        CalendarEvent(
            id: uuid("evt-eid-adha-2027"),
            name: "Eid al-Adha",
            date: date(2027, 5, 26),
            category: .religious,
            recommendedEditName: "Eid Ready"
        ),
        CalendarEvent(
            id: uuid("evt-rosh-hashanah-2026"),
            name: "Rosh Hashanah",
            date: date(2026, 9, 12),
            category: .religious,
            recommendedEditName: "High Holidays"
        ),
        CalendarEvent(
            id: uuid("evt-lds-general-conf-2026"),
            name: "LDS General Conference",
            date: date(2026, 10, 3),
            category: .religious,
            recommendedEditName: "Sunday Best"
        )
    ]

    // MARK: - Products
    //
    // 24 products across 8 brands. The vast majority match Amina's default DNA.
    // EXACTLY 4 are intentionally OUT (marked OUT-OF-DNA in comments below):
    //   - Verona "Plum V-Neck Wrap Midi"           (V-neck, midi hem)
    //   - Sweet Salt "Coral Elbow-Sleeve Sundress" (elbow sleeve)
    //   - Sweet Salt "Sage Knee-Length Sweater Dress" (knee hem)
    //   - Dainty Jewell's "Ivory Sheer-Sleeve Blouse"  (sheer)

    private static func p(
        _ seed: String,
        brand: String,
        name: String,
        retail: Decimal,
        buy: Decimal,
        category: ProductCategory,
        neckline: Neckline = .high,
        sleeve: SleeveLength = .long,
        hem: HemLength = .anklePlus,
        opacity: Opacity = .fullyOpaque,
        silhouette: Silhouette = .relaxed,
        tags: Set<ModestyTag> = [.hijabFriendly, .prayerFriendly],
        sizes: [Size] = [.xs, .s, .m, .l, .xl]
    ) -> Product {
        Product(
            id: uuid("prod-\(seed)"),
            brand: brand,
            name: name,
            priceRetail: retail,
            priceBuyDiscount: buy,
            imageAssetName: nil,
            modestyDNA: ModestyDNA(
                neckline: neckline,
                sleeve: sleeve,
                hem: hem,
                opacity: opacity,
                silhouette: silhouette,
                optionalTags: tags
            ),
            category: category,
            availableSizes: sizes
        )
    }

    static let products: [Product] = [

        // Aab — $90–180 — 3 items
        p("aab-olive-belted",  brand: "Aab", name: "Olive Linen Belted Maxi Dress",
          retail: 148, buy: 92, category: .modestMaxis),
        p("aab-camel-trouser", brand: "Aab", name: "Camel Wool Wide-Leg Trouser Set",
          retail: 172, buy: 108, category: .workwear, silhouette: .veryLoose),
        p("aab-ivory-crepe",   brand: "Aab", name: "Ivory Crepe Modest Blouse",
          retail: 94, buy: 58, category: .workwear),

        // INAYAH — $80–160 — 3 items
        p("inayah-charcoal-abaya", brand: "INAYAH", name: "Charcoal Crepe Open Abaya",
          retail: 138, buy: 84, category: .everyday, silhouette: .veryLoose),
        p("inayah-rose-jersey",    brand: "INAYAH", name: "Dusty Rose Jersey Maxi",
          retail: 88, buy: 54, category: .everyday),
        p("inayah-emerald-eid",    brand: "INAYAH", name: "Emerald Embroidered Eid Gown",
          retail: 158, buy: 96, category: .eidReady, silhouette: .tailored),

        // Mikarose — $50–90 — 3 items
        p("mikarose-navy-swing",   brand: "Mikarose", name: "Navy Swing Maxi Dress",
          retail: 78, buy: 48, category: .everyday),
        p("mikarose-floral-prairie", brand: "Mikarose", name: "Floral Prairie Maxi",
          retail: 84, buy: 52, category: .modestMaxis),
        p("mikarose-rust-shirtdress", brand: "Mikarose", name: "Rust Long-Sleeve Shirtdress",
          retail: 68, buy: 42, category: .everyday, silhouette: .tailored),

        // Verona Collection — $40–110 — 3 items
        p("verona-black-blazer",   brand: "Verona Collection", name: "Black Tailored Blazer Dress",
          retail: 108, buy: 68, category: .workwear, silhouette: .tailored),
        p("verona-tan-suit",       brand: "Verona Collection", name: "Tan Three-Piece Suit Set",
          retail: 102, buy: 64, category: .workwear, silhouette: .tailored),
        // OUT-OF-DNA #1 — V-neck + midi hem
        p("verona-plum-vneck",     brand: "Verona Collection", name: "Plum V-Neck Wrap Midi",
          retail: 64, buy: 38, category: .occasion,
          neckline: .vNeck, hem: .midi, silhouette: .tailored,
          tags: []),

        // Sweet Salt — $35–75 — 3 items
        p("sweetsalt-blush-maxi",  brand: "Sweet Salt", name: "Blush Tiered Cotton Maxi",
          retail: 58, buy: 36, category: .everyday),
        // OUT-OF-DNA #2 — elbow sleeve (revealed when user loosens sleeve filter to "elbow OK")
        p("sweetsalt-coral-elbow", brand: "Sweet Salt", name: "Coral Elbow-Sleeve Sundress",
          retail: 48, buy: 30, category: .everyday,
          sleeve: .elbow),
        // OUT-OF-DNA #3 — knee hem
        p("sweetsalt-sage-sweater", brand: "Sweet Salt", name: "Sage Knee-Length Sweater Dress",
          retail: 72, buy: 44, category: .everyday,
          hem: .knee, silhouette: .relaxed),

        // Dainty Jewell's — $60–130 — 3 items
        p("dainty-cream-prairie",  brand: "Dainty Jewell's", name: "Cream Prairie Lace Gown",
          retail: 128, buy: 78, category: .occasion, silhouette: .relaxed),
        p("dainty-navy-puff",      brand: "Dainty Jewell's", name: "Navy Puff-Sleeve Tea Dress",
          retail: 96, buy: 60, category: .occasion, silhouette: .tailored),
        // OUT-OF-DNA #4 — sheer (no slip baked in)
        p("dainty-ivory-sheer",    brand: "Dainty Jewell's", name: "Ivory Sheer-Sleeve Blouse",
          retail: 62, buy: 38, category: .workwear,
          opacity: .sheerWithSlipOK, silhouette: .tailored, tags: []),

        // Haute Hijab — $40–65 — 3 items (treat hem as ankle-plus add-ons / scarves)
        p("haute-blackbamboo",    brand: "Haute Hijab", name: "Black Bamboo Jersey Hijab",
          retail: 42, buy: 28, category: .everyday),
        p("haute-rose-chiffon",   brand: "Haute Hijab", name: "Rose Chiffon Hijab",
          retail: 54, buy: 34, category: .occasion),
        p("haute-cream-silk",     brand: "Haute Hijab", name: "Cream Silk Square Hijab",
          retail: 64, buy: 40, category: .eidReady),

        // Zahraa the Label — $50–140 — 3 items
        p("zahraa-olive-jumpsuit", brand: "Zahraa the Label", name: "Olive Wide-Leg Jumpsuit",
          retail: 132, buy: 82, category: .occasion, silhouette: .veryLoose),
        p("zahraa-mocha-shacket",  brand: "Zahraa the Label", name: "Mocha Long Shacket",
          retail: 96, buy: 60, category: .newThisWeek, silhouette: .relaxed),
        p("zahraa-black-pleated",  brand: "Zahraa the Label", name: "Black Pleated Maxi Skirt",
          retail: 78, buy: 48, category: .modestMaxis)
    ]

    // MARK: - Sample user

    static let aminaProfile = UserProfile.amina

    // MARK: - Preview fixtures

    enum PreviewData {
        static let sampleProduct      = MockData.products[0]
        static let sampleUser         = MockData.aminaProfile
        static let signaturePlan      = MockData.signaturePlan
        static let modestEditPlan     = MockData.modestEditPlan
        static let unlimitedPlan      = MockData.unlimitedPlan
        static let sampleEvent        = MockData.events[0]
        static let sampleProducts     = MockData.products
        static let aminasBox          = Array(MockData.products.prefix(6))
    }
}
