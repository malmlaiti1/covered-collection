import SwiftUI

/// Reusable axis selector. Renders a horizontally scrolling row of option cards.
struct AxisStepView<Option: Hashable & Identifiable>: View {
    let title: String
    let subtitle: String
    let options: [Option]
    let label: (Option) -> String
    let symbol: (Option) -> String
    @Binding var selection: Option

    var body: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
            VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
                Text(title).font(.laylaDisplay).foregroundStyle(.laylaInk)
                Text(subtitle).font(.laylaBody).foregroundStyle(.laylaMuted)
            }
            .padding(.horizontal, LaylaSpacing.lg)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: LaylaSpacing.md) {
                    ForEach(options) { option in
                        OptionCard(
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
                .padding(.horizontal, LaylaSpacing.lg)
            }
        }
    }
}

private struct OptionCard: View {
    let label: String
    let symbol: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: LaylaSpacing.md) {
            Image(systemName: symbol)
                .font(.system(size: 34, weight: .light))
                .foregroundStyle(isSelected ? Color.laylaCream : Color.laylaOlive)
                .frame(width: 64, height: 64)
                .background(Circle().fill(isSelected ? Color.laylaOlive : Color.laylaTagBg))
            Text(label)
                .font(.laylaCaption.weight(.medium))
                .foregroundStyle(isSelected ? .laylaCream : .laylaInk)
                .multilineTextAlignment(.center)
        }
        .frame(width: 130, height: 160)
        .background(isSelected ? Color.laylaOlive : Color.laylaSurface)
        .clipShape(RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous)
                .stroke(isSelected ? Color.laylaOlive : Color.laylaBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(isSelected ? 0.10 : 0.04), radius: 8, x: 0, y: 4)
    }
}
