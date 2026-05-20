import Foundation

enum CancellationReason: String, Codable, CaseIterable, Identifiable {
    case price
    case fit
    case frequency
    case noTime
    case other

    var id: String { rawValue }

    var displayName: String { "" }
}
