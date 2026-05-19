import SwiftUI

// MARK: - Tone Gradient
//
// Mirrors `toneGradient()` from the design's components.jsx: lighten one corner,
// darken the opposite — yields a soft "fabric drape" feel on product imagery.

enum ToneGradient {
    static func make(base: Color) -> LinearGradient {
        LinearGradient(
            colors: [base.lightened(by: 0.10), base, base.darkened(by: 0.09)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Color {
    /// Lighten by blending toward white (amt is 0…1).
    func lightened(by amt: CGFloat) -> Color {
        Color(UIColor(self).blended(toward: .white, amount: amt))
    }

    /// Darken by blending toward black (amt is 0…1).
    func darkened(by amt: CGFloat) -> Color {
        Color(UIColor(self).blended(toward: .black, amount: amt))
    }
}

private extension UIColor {
    func blended(toward other: UIColor, amount t: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let lerp: (CGFloat, CGFloat) -> CGFloat = { a, b in a + (b - a) * t }
        return UIColor(red: lerp(r1, r2), green: lerp(g1, g2), blue: lerp(b1, b2), alpha: lerp(a1, a2))
    }
}

// MARK: - Sheen Overlay
//
// 115° diagonal sheen used over product imagery — bright slash top-left,
// soft shadow bottom-right. Matches the gradient layered in `ProductImage`.

struct SheenOverlay: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: .white.opacity(0.10),   location: 0.0),
                .init(color: .clear,                 location: 0.30),
                .init(color: .clear,                 location: 0.70),
                .init(color: .black.opacity(0.08),   location: 1.0),
            ],
            startPoint: UnitPoint(x: 0, y: 0.15),
            endPoint:   UnitPoint(x: 1, y: 0.85)
        )
        .allowsHitTesting(false)
    }
}

// MARK: - Noise Overlay
//
// Subtle film-grain to keep imagery from looking flat. The web design uses an
// SVG turbulence filter at 6% opacity / overlay blend. We approximate with a
// dotted Canvas at low alpha, which is cheap and tiles cleanly.

struct NoiseOverlay: View {
    var opacity: Double = 0.06

    var body: some View {
        Canvas { context, size in
            // Deterministic so the texture is stable across redraws.
            var rng = SplitMix64(seed: 0xC0FFEE)
            let dotCount = Int((size.width * size.height) / 36)
            for _ in 0..<dotCount {
                let x = CGFloat(rng.nextUnit()) * size.width
                let y = CGFloat(rng.nextUnit()) * size.height
                let s = CGFloat(rng.nextUnit()) * 0.9 + 0.3
                let rect = CGRect(x: x, y: y, width: s, height: s)
                context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.6)))
            }
        }
        .blendMode(.overlay)
        .opacity(opacity)
        .allowsHitTesting(false)
    }
}

/// Tiny deterministic PRNG so the noise pattern doesn't shimmer on redraws.
private struct SplitMix64 {
    var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z &>> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z &>> 27)) &* 0x94D049BB133111EB
        return z ^ (z &>> 31)
    }
    mutating func nextUnit() -> Double {
        Double(next() >> 11) / Double(1 << 53)
    }
}
