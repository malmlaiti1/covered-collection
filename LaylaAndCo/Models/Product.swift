import Foundation

enum ProductCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case workwear, eidReady, everyday, occasion, newThisWeek, modestMaxis
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .workwear:    return "Workwear"
        case .eidReady:    return "Eid Ready"
        case .everyday:    return "Everyday"
        case .occasion:    return "Occasion"
        case .newThisWeek: return "New This Week"
        case .modestMaxis: return "Modest Maxis"
        }
    }
    var symbol: String {
        switch self {
        case .workwear:    return "briefcase"
        case .eidReady:    return "sparkles"
        case .everyday:    return "sun.max"
        case .occasion:    return "wand.and.stars"
        case .newThisWeek: return "star.circle"
        case .modestMaxis: return "rectangle.portrait"
        }
    }
}

enum Size: String, Codable, CaseIterable, Identifiable, Hashable {
    case xs, s, m, l, xl
    var id: String { rawValue }
    var displayName: String { rawValue.uppercased() }
}

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    let brand: String
    let name: String
    let priceRetail: Decimal
    let priceBuyDiscount: Decimal
    let imageAssetName: String?
    let modestyDNA: ModestyDNA
    let category: ProductCategory
    let availableSizes: [Size]
}
