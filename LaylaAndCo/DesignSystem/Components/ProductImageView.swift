import SwiftUI

/// Renders a product image.
/// Tries `Assets.xcassets/Products/<imageAssetName>` first, then falls back to a procedural
/// brand-tone rectangle with the brand name in small-caps serif and the product name beneath it.
///
/// A `#if USE_REMOTE_IMAGES` branch keeps an `AsyncImage` code path available for the future
/// real backend, but is OFF by default so the demo is guaranteed offline-clean.
struct ProductImageView: View {
    let product: Product
    var aspect: CGFloat = 3.0 / 4.0
    var cornerRadius: CGFloat = LaylaSpacing.cardCorner
    var showsBrandLabel: Bool = true

    var body: some View {
        ZStack {
            if let asset = product.imageAssetName, UIImage(named: asset) != nil {
                Image(asset)
                    .resizable()
                    .scaledToFill()
            } else {
                #if USE_REMOTE_IMAGES
                AsyncImage(url: URL(string: "https://example.invalid")) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFill()
                    default: procedural
                    }
                }
                #else
                procedural
                #endif
            }
        }
        .aspectRatio(aspect, contentMode: .fill)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityLabel(Text("\(product.brand) — \(product.name)"))
    }

    private var procedural: some View {
        let tone = BrandTone.tone(forSeed: product.id.uuidString)
        return ZStack {
            LinearGradient(
                colors: [tone.background, tone.background.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            if showsBrandLabel {
                VStack(spacing: LaylaSpacing.sm) {
                    Spacer()
                    Text(product.brand)
                        .font(.system(.footnote, design: .serif).weight(.medium))
                        .textCase(.uppercase)
                        .tracking(2.4)
                        .foregroundStyle(tone.foreground)
                    Text(product.name)
                        .font(.system(.caption2, design: .serif))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(tone.foreground.opacity(0.82))
                        .padding(.horizontal, LaylaSpacing.md)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    VStack {
        ProductImageView(product: MockData.PreviewData.sampleProduct)
            .frame(width: 180)
    }
    .padding()
    .background(Color.laylaCream)
}
