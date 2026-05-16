import SwiftUI

struct LaylaCard<Content: View>: View {
    var background: Color = .laylaSurface
    var stroke: Color? = .laylaBorder
    var padding: CGFloat = LaylaSpacing.md
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous)
                    .stroke(stroke ?? .clear, lineWidth: stroke == nil ? 0 : 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    LaylaCard {
        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
            Text("AAB").laylaSmallCaps().foregroundStyle(.laylaMuted)
            Text("Olive Linen Belted Maxi Dress")
                .font(.laylaTitle)
                .foregroundStyle(.laylaInk)
            Text("$148")
                .font(.laylaBodyEmph)
                .foregroundStyle(.laylaOlive)
        }
    }
    .padding()
    .background(Color.laylaCream)
}
