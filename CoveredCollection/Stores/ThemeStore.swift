import Foundation
import Observation

/// Holds the user's chosen brand accent. Persisted to UserDefaults.
///
/// `Color.coveredOlive` / `Color.coveredOliveDark` resolve through
/// `ThemeStore.shared.accent`, so views observing this store rebuild and
/// every brand-color reference picks up the new hue automatically.
@Observable
final class ThemeStore {
    static let shared = ThemeStore()
    private static let storageKey = "themeAccent"

    var accent: BrandAccent {
        didSet {
            UserDefaults.standard.set(accent.rawValue, forKey: Self.storageKey)
        }
    }

    init() {
        if let raw = UserDefaults.standard.string(forKey: Self.storageKey),
           let parsed = BrandAccent(rawValue: raw) {
            self.accent = parsed
        } else {
            self.accent = .olive
        }
    }
}
