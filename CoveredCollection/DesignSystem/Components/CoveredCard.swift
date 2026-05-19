import SwiftUI

struct CoveredCard<Content: View>: View {
    var background: Color = .coveredSurface
    var stroke: Color? = .coveredBorder
    var padding: CGFloat = CoveredSpacing.md
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous)
                    .stroke(stroke ?? .clear, lineWidth: stroke == nil ? 0 : 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    CoveredCard {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("AAB").coveredSmallCaps().foregroundStyle(.coveredMuted)
            Text("Olive Linen Belted Maxi Dress")
                .font(.coveredTitle)
                .foregroundStyle(.coveredInk)
            Text("$148")
                .font(.coveredBodyEmph)
                .foregroundStyle(.coveredOlive)
        }
    }
    .padding()
    .background(Color.coveredCream)
}
