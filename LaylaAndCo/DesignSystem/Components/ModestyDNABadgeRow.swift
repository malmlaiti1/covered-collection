import SwiftUI

struct ModestyDNABadgeRow: View {
    let dna: ModestyDNA
    var compact: Bool = true

    var body: some View {
        HStack(spacing: compact ? LaylaSpacing.xs : LaylaSpacing.sm) {
            badge(symbol: "arrow.up.to.line.compact", text: dna.neckline.displayName)
            badge(symbol: "hand.raised", text: dna.sleeve.displayName)
            badge(symbol: "ruler", text: dna.hem.displayName)
            if !compact {
                badge(symbol: "circle.lefthalf.filled", text: dna.opacity.displayName)
                badge(symbol: "figure.stand", text: dna.silhouette.displayName)
            }
        }
    }

    private func badge(symbol: String, text: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: symbol)
                .font(.system(size: compact ? 9 : 11, weight: .medium))
            if !compact {
                Text(text)
                    .font(.caption2)
            }
        }
        .padding(.horizontal, compact ? 6 : LaylaSpacing.sm)
        .padding(.vertical, 4)
        .foregroundStyle(Color.laylaOlive)
        .background(Color.laylaTagBg)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: LaylaSpacing.md) {
        ModestyDNABadgeRow(dna: .aminaDefault, compact: true)
        ModestyDNABadgeRow(dna: .aminaDefault, compact: false)
    }
    .padding()
    .background(Color.laylaCream)
}
