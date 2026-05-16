import SwiftUI

/// Deterministic brand-tone palette used by the procedural product placeholders.
/// Picked so the demo looks polished offline — no remote image fetching.
enum BrandTone: Int, CaseIterable {
    case olive, rose, sand, oat, plum, slate

    var background: Color {
        switch self {
        case .olive: return Color(red: 0.30, green: 0.36, blue: 0.27)
        case .rose:  return Color(red: 0.78, green: 0.61, blue: 0.55)
        case .sand:  return Color(red: 0.87, green: 0.79, blue: 0.65)
        case .oat:   return Color(red: 0.94, green: 0.90, blue: 0.82)
        case .plum:  return Color(red: 0.47, green: 0.32, blue: 0.36)
        case .slate: return Color(red: 0.42, green: 0.45, blue: 0.48)
        }
    }

    var foreground: Color {
        switch self {
        case .oat, .sand: return Color.laylaInk
        default:          return Color.laylaCream
        }
    }

    static func tone(forSeed seed: String) -> BrandTone {
        let h = abs(seed.hashValue) % BrandTone.allCases.count
        return BrandTone.allCases[h]
    }
}
