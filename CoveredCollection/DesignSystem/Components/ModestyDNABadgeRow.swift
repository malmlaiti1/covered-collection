import SwiftUI

/// 5-column grid summarising a `ModestyDNA`. Each cell shows a small-caps axis
/// label ("NECK") over the chosen value ("Modest Scoop"). Used on onboarding
/// success, the account DNA card, and (compact) wherever space is tight.
struct ModestyDNABadgeRow: View {
    let dna: ModestyDNA
    var compact: Bool = false

    private struct Axis: Hashable {
        let label: String
        let value: String
    }

    private var axes: [Axis] {
        [
            Axis(label: "Neck",   value: dna.neckline.displayName),
            Axis(label: "Sleeve", value: dna.sleeve.displayName),
            Axis(label: "Hem",    value: dna.hem.displayName),
            Axis(label: "Fabric", value: dna.opacity.displayName),
            Axis(label: "Fit",    value: dna.silhouette.displayName),
        ]
    }

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 6, alignment: .top),
        count: 5
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(axes, id: \.self) { axis in
                cell(axis)
            }
        }
    }

    private func cell(_ axis: Axis) -> some View {
        VStack(spacing: 3) {
            Text(axis.label)
                .font(.system(size: 8.5, weight: .medium))
                .tracking(1.6)
                .textCase(.uppercase)
                .foregroundStyle(.coveredMuted)
            Text(axis.value)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.coveredInk)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
        .padding(.vertical, compact ? 6 : 10)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity)
        .background(Color.coveredTagBg)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    VStack(spacing: CoveredSpacing.md) {
        ModestyDNABadgeRow(dna: .aminaDefault)
        ModestyDNABadgeRow(dna: .aminaDefault, compact: true)
    }
    .padding()
    .background(Color.coveredCream)
}
