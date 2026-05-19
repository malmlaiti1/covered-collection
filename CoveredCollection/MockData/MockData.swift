import Foundation

enum MockData {

    // MARK: - Product helper
    //
    // `seed` doubles as both a stable identity (folded into the UUID) and the
    // asset-catalog key. Imagesets live under `Assets.xcassets/Products/<seed>`,
    // so `imageAssetName` resolves to `"Products/<seed>"`. The seeds and asset
    // names must stay in sync.

    private static func p(
        seed: String,
        brand: String,
        name: String,
        priceRetail: Decimal,
        priceBuyDiscount: Decimal,
        modestyDNA: ModestyDNA,
        availableSizes: [Size],
        category: ProductCategory
    ) -> Product {
        Product(
            id: uuid(forSeed: seed),
            brand: brand,
            name: name,
            priceRetail: priceRetail,
            priceBuyDiscount: priceBuyDiscount,
            modestyDNA: modestyDNA,
            availableSizes: availableSizes,
            category: category,
            imageAssetName: "Products/\(seed)"
        )
    }

    /// Deterministic UUID from a seed string — same seed always yields the
    /// same UUID across launches so saved/queue state survives restarts.
    private static func uuid(forSeed seed: String) -> UUID {
        var bytes: [UInt8] = Array(repeating: 0, count: 16)
        for (i, byte) in seed.utf8.enumerated() {
            bytes[i % 16] &+= byte
        }
        // RFC 4122 variant + version 4 bits, so the value is a valid UUID.
        bytes[6] = (bytes[6] & 0x0F) | 0x40
        bytes[8] = (bytes[8] & 0x3F) | 0x80
        return UUID(uuid: (
            bytes[0],  bytes[1],  bytes[2],  bytes[3],
            bytes[4],  bytes[5],  bytes[6],  bytes[7],
            bytes[8],  bytes[9],  bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }

    // MARK: - Products

    static let products: [Product] = [
        p(
            seed: "sweetsalt-blush-maxi",
            brand: "Sweet Salt",
            name: "Blush Tiered Maxi Dress",
            priceRetail: 138,
            priceBuyDiscount: 83,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "zahraa-black-pleated",
            brand: "Zahraa Couture",
            name: "Black Pleated Midi Skirt",
            priceRetail: 96,
            priceBuyDiscount: 58,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .midi, opacity: .fullyOpaque, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl, .xxl],
            category: .bottoms
        ),
        p(
            seed: "verona-tan-suit",
            brand: "Verona Collection",
            name: "Tan Two-Piece Suit",
            priceRetail: 268,
            priceBuyDiscount: 161,
            modestyDNA: ModestyDNA(neckline: .vNeck, sleeve: .long, hem: .midi, opacity: .fullyOpaque, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .outerwear
        ),
        p(
            seed: "inayah-charcoal-abaya",
            brand: "Inayah",
            name: "Charcoal Open Abaya",
            priceRetail: 195,
            priceBuyDiscount: 117,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .veryLoose),
            availableSizes: [.s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "verona-black-blazer",
            brand: "Verona Collection",
            name: "Black Tailored Blazer",
            priceRetail: 175,
            priceBuyDiscount: 105,
            modestyDNA: ModestyDNA(neckline: .vNeck, sleeve: .long, hem: .midi, opacity: .fullyOpaque, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .outerwear
        ),
        p(
            seed: "aab-camel-trouser",
            brand: "Aab Collection",
            name: "Camel Wide-Leg Trouser",
            priceRetail: 118,
            priceBuyDiscount: 71,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl, .xxl],
            category: .bottoms
        ),
        p(
            seed: "inayah-rose-jersey",
            brand: "Inayah",
            name: "Rose Jersey Wrap Dress",
            priceRetail: 124,
            priceBuyDiscount: 75,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "sweetsalt-sage-sweater",
            brand: "Sweet Salt",
            name: "Sage Ribbed Sweater",
            priceRetail: 82,
            priceBuyDiscount: 49,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .knee, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .tops
        ),
        p(
            seed: "zahraa-mocha-shacket",
            brand: "Zahraa Couture",
            name: "Mocha Belted Shacket",
            priceRetail: 168,
            priceBuyDiscount: 101,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .knee, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .outerwear
        ),
        p(
            seed: "aab-ivory-crepe",
            brand: "Aab Collection",
            name: "Ivory Crepe Column Dress",
            priceRetail: 158,
            priceBuyDiscount: 95,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "zahraa-olive-jumpsuit",
            brand: "Zahraa Couture",
            name: "Olive Wide-Leg Jumpsuit",
            priceRetail: 162,
            priceBuyDiscount: 97,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "mikarose-rust-shirtdress",
            brand: "Mikarose",
            name: "Rust Belted Shirtdress",
            priceRetail: 128,
            priceBuyDiscount: 77,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .midi, opacity: .fullyOpaque, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "haute-rose-chiffon",
            brand: "Haute Hijab",
            name: "Rose Printed Chiffon Hijab",
            priceRetail: 48,
            priceBuyDiscount: 29,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .linedRequired, silhouette: .veryLoose),
            availableSizes: [.m],
            category: .accessories
        ),
        p(
            seed: "mikarose-navy-swing",
            brand: "Mikarose",
            name: "Navy Swing Midi Dress",
            priceRetail: 118,
            priceBuyDiscount: 71,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .midi, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "inayah-emerald-eid",
            brand: "Inayah",
            name: "Emerald Embroidered Eid Gown",
            priceRetail: 248,
            priceBuyDiscount: 149,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .veryLoose),
            availableSizes: [.s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "sweetsalt-coral-elbow",
            brand: "Sweet Salt",
            name: "Coral Elbow-Sleeve Blouse",
            priceRetail: 68,
            priceBuyDiscount: 41,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .elbow, hem: .knee, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .tops
        ),
        p(
            seed: "aab-olive-belted",
            brand: "Aab Collection",
            name: "Olive Belted Maxi Dress",
            priceRetail: 148,
            priceBuyDiscount: 89,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "haute-blackbamboo",
            brand: "Haute Hijab",
            name: "Black Bamboo Jersey Hijab",
            priceRetail: 32,
            priceBuyDiscount: 19,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .veryLoose),
            availableSizes: [.m],
            category: .accessories
        ),
        p(
            seed: "dainty-ivory-sheer",
            brand: "Dainty Jewell's",
            name: "Ivory Sheer-Sleeve Blouse",
            priceRetail: 78,
            priceBuyDiscount: 47,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .knee, opacity: .linedRequired, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .tops
        ),
        p(
            seed: "mikarose-floral-prairie",
            brand: "Mikarose",
            name: "Floral Prairie Maxi Dress",
            priceRetail: 138,
            priceBuyDiscount: 83,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
        p(
            seed: "verona-plum-vneck",
            brand: "Verona Collection",
            name: "Plum V-Neck Knit Top",
            priceRetail: 72,
            priceBuyDiscount: 43,
            modestyDNA: ModestyDNA(neckline: .vNeck, sleeve: .long, hem: .knee, opacity: .fullyOpaque, silhouette: .tailored),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .tops
        ),
        p(
            seed: "dainty-navy-puff",
            brand: "Dainty Jewell's",
            name: "Navy Puff-Sleeve Blouse",
            priceRetail: 82,
            priceBuyDiscount: 49,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .knee, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .tops
        ),
        p(
            seed: "haute-cream-silk",
            brand: "Haute Hijab",
            name: "Cream Printed Silk Hijab",
            priceRetail: 58,
            priceBuyDiscount: 35,
            modestyDNA: ModestyDNA(neckline: .high, sleeve: .long, hem: .anklePlus, opacity: .linedRequired, silhouette: .veryLoose),
            availableSizes: [.m],
            category: .accessories
        ),
        p(
            seed: "dainty-cream-prairie",
            brand: "Dainty Jewell's",
            name: "Cream Tiered Prairie Dress",
            priceRetail: 142,
            priceBuyDiscount: 85,
            modestyDNA: ModestyDNA(neckline: .modestScoop, sleeve: .long, hem: .anklePlus, opacity: .fullyOpaque, silhouette: .relaxed),
            availableSizes: [.xs, .s, .m, .l, .xl],
            category: .dresses
        ),
    ]

    // MARK: - Plans

    static let plans: [SubscriptionPlan] = [
        SubscriptionPlan(
            id: UUID(uuidString: "00000002-0000-0000-0000-000000000001")!,
            name: "Essentials",
            tagline: "3 pieces per month",
            pricePerMonth: 59,
            features: [
                "3 curated pieces/month",
                "Free shipping & returns",
                "Subscriber buy discount",
            ],
            isFeatured: false
        ),
        SubscriptionPlan(
            id: UUID(uuidString: "00000002-0000-0000-0000-000000000002")!,
            name: "Style",
            tagline: "5 pieces per month — most popular",
            pricePerMonth: 89,
            features: [
                "5 curated pieces/month",
                "Free shipping & returns",
                "15% subscriber buy discount",
                "Priority DNA matching",
            ],
            isFeatured: true
        ),
        SubscriptionPlan(
            id: UUID(uuidString: "00000002-0000-0000-0000-000000000003")!,
            name: "Luxury",
            tagline: "8 pieces — designer edits included",
            pricePerMonth: 149,
            features: [
                "8 curated pieces/month",
                "Free shipping & returns",
                "20% subscriber buy discount",
                "Designer & occasion edits",
                "Dedicated stylist",
            ],
            isFeatured: false
        ),
    ]

    // MARK: - Events

    static let events: [CalendarEvent] = [
        CalendarEvent(
            id: UUID(uuidString: "00000003-0000-0000-0000-000000000001")!,
            name: "Eid Al-Fitr",
            date: Calendar.current.date(byAdding: .day, value: 45, to: .now)!,
            category: .eid,
            recommendedEditName: "Eid Elegance Edit"
        ),
        CalendarEvent(
            id: UUID(uuidString: "00000003-0000-0000-0000-000000000002")!,
            name: "Sara's Wedding",
            date: Calendar.current.date(byAdding: .day, value: 18, to: .now)!,
            category: .wedding,
            recommendedEditName: "Wedding Guest Edit"
        ),
        CalendarEvent(
            id: UUID(uuidString: "00000003-0000-0000-0000-000000000003")!,
            name: "Graduation Ceremony",
            date: Calendar.current.date(byAdding: .day, value: 72, to: .now)!,
            category: .graduation,
            recommendedEditName: nil
        ),
        CalendarEvent(
            id: UUID(uuidString: "00000003-0000-0000-0000-000000000004")!,
            name: "Office Gala",
            date: Calendar.current.date(byAdding: .day, value: 9, to: .now)!,
            category: .formal,
            recommendedEditName: "Modest Formal Edit"
        ),
        CalendarEvent(
            id: UUID(uuidString: "00000003-0000-0000-0000-000000000005")!,
            name: "Family Picnic",
            date: Calendar.current.date(byAdding: .day, value: 3, to: .now)!,
            category: .casual,
            recommendedEditName: nil
        ),
    ]

    // MARK: - Preview Data

    enum PreviewData {
        static let sampleProduct: Product = products[0]
        static let sampleProducts: [Product] = Array(products.prefix(6))
    }
}
