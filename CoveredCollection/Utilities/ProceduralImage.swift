import SwiftUI

enum BrandTone: Int, CaseIterable {
    case olive, rose, sand, oat, plum, slate

    var background: Color {
        switch self {
        case .olive: return Color.coveredOlive                            // follows ThemeStore accent
        case .rose:  return Color(red: 0.78,  green: 0.575, blue: 0.51)   // dusty terracotta-rose
        case .sand:  return Color(red: 0.78,  green: 0.66,  blue: 0.49)   // warm camel
        case .oat:   return Color(red: 0.91,  green: 0.86,  blue: 0.76)   // soft oat
        case .plum:  return Color(red: 0.40,  green: 0.27,  blue: 0.32)   // muted plum
        case .slate: return Color(red: 0.36,  green: 0.40,  blue: 0.42)   // warm slate
        }
    }

    var foreground: Color {
        switch self {
        case .oat, .sand: return Color.coveredInk
        default:          return Color.coveredCream
        }
    }

    static func tone(forSeed seed: String) -> BrandTone {
        let h = abs(seed.hashValue) % BrandTone.allCases.count
        return BrandTone.allCases[h]
    }
}
