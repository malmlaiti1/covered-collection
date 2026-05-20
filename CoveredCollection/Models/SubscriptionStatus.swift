import Foundation

enum SubscriptionStatus: String, Codable {
    case active
    case paused
    case cancelled
}

enum CounterOffer: Identifiable, Equatable {
    case discountedMonth(price: Int)
    case pause(days: Int)
    case downgradeToCore

    var id: String { "" }

    var headline: String { "" }

    var subhead: String { "" }
}
