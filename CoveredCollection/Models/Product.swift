import Foundation

// MARK: - ProductCategory

enum ProductCategory: String, CaseIterable, Identifiable, Hashable {
    case dresses, tops, bottoms, outerwear, accessories
    var id: Self { self }
    var displayName: String {
        switch self {
        case .dresses:     return "Dresses"
        case .tops:        return "Tops"
        case .bottoms:     return "Bottoms"
        case .outerwear:   return "Outerwear"
        case .accessories: return "Accessories"
        }
    }
    var symbol: String {
        switch self {
        case .dresses:     return "figure.stand.dress"
        case .tops:        return "tshirt"
        case .bottoms:     return "rectangle.split.1x2.fill"
        case .outerwear:   return "snowflake"
        case .accessories: return "handbag.fill"
        }
    }
}

// MARK: - Size

enum Size: String, CaseIterable, Identifiable, Hashable {
    case xs, s, m, l, xl, xxl
    var id: Self { self }
    var displayName: String { rawValue.uppercased() }
}

// MARK: - Product

struct Product: Identifiable, Hashable {
    let id: UUID
    let brand: String
    let name: String
    let priceRetail: Decimal
    let priceBuyDiscount: Decimal
    let modestyDNA: ModestyDNA
    let availableSizes: [Size]
    let category: ProductCategory
    var imageAssetName: String? = nil
}
