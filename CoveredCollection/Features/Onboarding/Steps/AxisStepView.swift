import SwiftUI

struct AxisStepView<Option: Hashable & Identifiable>: View {
    let title: String
    let subtitle: String
    let options: [Option]
    let label: (Option) -> String
    let symbol: (Option) -> String
    @Binding var selection: Option

    var body: some View {
        VStack(spacing: CoveredSpacing.lg) {
            VStack(spacing: CoveredSpacing.sm) {
                Text(title)
                    .font(.coveredDisplay)
                    .foregroundStyle(.coveredInk)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(.coveredBody)
                    .foregroundStyle(.coveredMuted)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, CoveredSpacing.lg)

            VStack(spacing: CoveredSpacing.sm) {
                ForEach(options) { option in
                    OptionRow(
                        label: label(option),
                        symbol: symbol(option),
                        isSelected: selection == option
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selection = option
                        }
                    }
                    .accessibilityAddTraits(selection == option ? .isSelected : [])
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct OptionRow: View {
    let label: String
    let symbol: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: CoveredSpacing.md) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.white.opacity(0.18) : Color.coveredTagBg)
                    .frame(width: 48, height: 48)
                Image(systemName: symbol)
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(isSelected ? Color.coveredCream : Color.coveredOlive)
            }
            Text(label)
                .font(.coveredBody.weight(.medium))
                .foregroundStyle(isSelected ? Color.coveredCream : Color.coveredInk)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.coveredCream)
            }
        }
        .padding(.horizontal, CoveredSpacing.md)
        .padding(.vertical, CoveredSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.coveredOlive : Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous)
                .stroke(isSelected ? Color.coveredOlive : Color.coveredBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(isSelected ? 0.10 : 0.04), radius: 8, x: 0, y: 4)
    }
}
