import Foundation

struct SubscriptionPlan: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let pricePerMonth: Decimal
    let itemsPerMonth: Int?
    let isUnlimited: Bool
    let tagline: String
    let features: [String]
    let isFeatured: Bool
}
