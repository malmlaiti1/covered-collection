import SwiftUI

// MARK: - Brand Palette
//
// Researched against premium modest fashion brands (Aab Collection, Hanayen, Vela):
// warm ivories instead of stark whites, sage-leaning olives for sophistication,
// antique brass instead of yellow gold, dusty terracotta-rose, warm charcoal,
// and soft taupe neutrals.
//
// `coveredOlive` (and `coveredOliveDark`) read the persisted accent directly
// from UserDefaults so this file has no dependencies on other types. The
// values match `BrandAccent` and the design's `app.css` tokens.

extension Color {
    /// Warm rich ivory — primary background
    static let coveredCream   = Color(red: 0.965, green: 0.945, blue: 0.905)
    /// Soft pearl — card and surface backgrounds (subtly lighter than cream)
    static let coveredSurface = Color(red: 0.995, green: 0.985, blue: 0.965)
    /// Primary brand color — resolved from the persisted accent in UserDefaults.
    static var coveredOlive: Color { CoveredAccentResolver.primary }
    /// Darker variant of the brand color — used for shadows and hover states.
    static var coveredOliveDark: Color { CoveredAccentResolver.primaryDark }
    /// Antique brass — warm metallic accent (replaces yellow gold)
    static let coveredGold    = Color(red: 0.72,  green: 0.555, blue: 0.305)
    /// Dusty terracotta rose — secondary accent
    static let coveredRose    = Color(red: 0.78,  green: 0.575, blue: 0.51)
    /// Warm rich charcoal — primary text
    static let coveredInk     = Color(red: 0.14,  green: 0.12,  blue: 0.10)
    /// Warm taupe — secondary/muted text
    static let coveredMuted   = Color(red: 0.50,  green: 0.455, blue: 0.41)
    /// Subtle warm border
    static let coveredBorder  = Color(red: 0.88,  green: 0.84,  blue: 0.77)
    /// Muted forest sage — success states (aligned with olive)
    static let coveredSuccess = Color(red: 0.36,  green: 0.505, blue: 0.345)
    /// Soft cream-sage — tag/pill backgrounds
    static let coveredTagBg   = Color(red: 0.92,  green: 0.905, blue: 0.835)
}

extension ShapeStyle where Self == Color {
    static var coveredCream:     Color { .coveredCream     }
    static var coveredSurface:   Color { .coveredSurface   }
    static var coveredOlive:     Color { .coveredOlive     }
    static var coveredOliveDark: Color { .coveredOliveDark }
    static var coveredGold:      Color { .coveredGold      }
    static var coveredRose:      Color { .coveredRose      }
    static var coveredInk:       Color { .coveredInk       }
    static var coveredMuted:     Color { .coveredMuted     }
    static var coveredBorder:    Color { .coveredBorder    }
    static var coveredSuccess:   Color { .coveredSuccess   }
    static var coveredTagBg:     Color { .coveredTagBg     }
}

// MARK: - Accent Resolver
//
// Self-contained helper that reads the persisted accent from UserDefaults so
// `Colors.swift` doesn't depend on any other type. The raw values mirror
// `BrandAccent`'s cases and hex tokens.

private enum CoveredAccentResolver {
    private static let storageKey = "themeAccent"

    static var primary: Color {
        switch raw {
        case "plum":  return Color(red: 0.40,  green: 0.27,  blue: 0.315)
        case "brass": return Color(red: 0.612, green: 0.455, blue: 0.215)
        case "slate": return Color(red: 0.29,  green: 0.335, blue: 0.376)
        default:      return Color(red: 0.305, green: 0.395, blue: 0.325) // olive
        }
    }

    static var primaryDark: Color {
        switch raw {
        case "plum":  return Color(red: 0.322, green: 0.216, blue: 0.255)
        case "brass": return Color(red: 0.494, green: 0.361, blue: 0.173)
        case "slate": return Color(red: 0.212, green: 0.251, blue: 0.290)
        default:      return Color(red: 0.239, green: 0.314, blue: 0.259) // olive dark
        }
    }

    private static var raw: String {
        UserDefaults.standard.string(forKey: storageKey) ?? "olive"
    }
}
