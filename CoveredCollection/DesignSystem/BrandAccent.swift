import SwiftUI

/// The brand-accent options surfaced in Account → Theme.
/// Values match the hex tokens documented in `app.css` from the design handoff.
enum BrandAccent: String, CaseIterable, Codable, Identifiable {
    case olive   // sage olive (default)
    case plum    // muted plum
    case brass   // antique brass
    case slate   // warm slate

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .olive: return "Sage Olive"
        case .plum:  return "Muted Plum"
        case .brass: return "Antique Brass"
        case .slate: return "Warm Slate"
        }
    }

    /// Primary brand color — replaces `Color.coveredOlive`.
    var primary: Color {
        switch self {
        case .olive: return Color(red: 0.305, green: 0.395, blue: 0.325) // #4E6553
        case .plum:  return Color(red: 0.40,  green: 0.27,  blue: 0.315) // #664550
        case .brass: return Color(red: 0.612, green: 0.455, blue: 0.215) // #9C7437
        case .slate: return Color(red: 0.29,  green: 0.335, blue: 0.376) // #4A5560
        }
    }

    /// Darker variant for deep accents, e.g. shadows under raised cards.
    var primaryDark: Color {
        switch self {
        case .olive: return Color(red: 0.239, green: 0.314, blue: 0.259) // #3D5042
        case .plum:  return Color(red: 0.322, green: 0.216, blue: 0.255) // #523741
        case .brass: return Color(red: 0.494, green: 0.361, blue: 0.173) // #7E5C2C
        case .slate: return Color(red: 0.212, green: 0.251, blue: 0.290) // #36404A
        }
    }
}
