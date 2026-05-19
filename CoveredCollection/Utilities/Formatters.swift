import Foundation

enum CoveredFormatters {
    static func priceText(_ d: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 0
        return f.string(from: d as NSDecimalNumber) ?? "$\(d)"
    }
}
