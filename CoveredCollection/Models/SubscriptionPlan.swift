import Foundation

struct SubscriptionPlan: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let tagline: String
    let pricePerMonth: Decimal
    let features: [String]
    let isFeatured: Bool
}
