import Foundation

/// User-selectable grid density for product cards.
/// Controls how many cards appear per row in the closet grid.
enum CardSize: String, CaseIterable, Identifiable, Codable {
    case small, medium, large

    var id: String { rawValue }

    /// Number of columns to render in a vertical grid.
    var columns: Int {
        switch self {
        case .small:  return 3
        case .medium: return 2
        case .large:  return 1
        }
    }

    /// SF Symbol used in the toolbar picker.
    var symbol: String {
        switch self {
        case .small:  return "square.grid.3x3"
        case .medium: return "square.grid.2x2"
        case .large:  return "square"
        }
    }

    var displayName: String {
        switch self {
        case .small:  return "Small"
        case .medium: return "Medium"
        case .large:  return "Large"
        }
    }
}
