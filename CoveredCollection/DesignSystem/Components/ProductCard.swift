import SwiftUI

struct ProductCard: View {
    let product: Product
    var isSaved: Bool = false
    var onToggleSave: (() -> Void)? = nil
    /// Number of procedural "shots" to display per card.
    var variantCount: Int = 3

    @State private var selectedVariant: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            ZStack(alignment: .bottomLeading) {
                imageCarousel
                heartButton
            }
            metadata
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    private var imageCarousel: some View {
        Color.clear
            .aspectRatio(4.0 / 5.0, contentMode: .fit)
            .overlay(
                TabView(selection: $selectedVariant) {
                    ForEach(0..<variantCount, id: \.self) { index in
                        ProductImageView(
                            product: product,
                            aspect: 4.0 / 5.0,
                            cornerRadius: 12,
                            variantIndex: index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(alignment: .bottom) {
                pageDots
                    .padding(.bottom, 8)
            }
    }

    private var pageDots: some View {
        HStack(spacing: 5) {
            ForEach(0..<variantCount, id: \.self) { index in
                Circle()
                    .fill(index == selectedVariant
                          ? Color.white.opacity(0.95)
                          : Color.white.opacity(0.45))
                    .frame(width: 5, height: 5)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.18))
        .clipShape(Capsule())
    }

    private var heartButton: some View {
        Button {
            onToggleSave?()
        } label: {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isSaved ? Color.coveredRose : Color.coveredInk)
                .frame(width: 32, height: 32)
                .background(.white.opacity(0.85))
                .clipShape(Circle())
        }
        .padding(CoveredSpacing.sm)
        .accessibilityLabel(isSaved ? "Remove from saved" : "Save")
    }

    private var metadata: some View {
        // Reserving line counts on every Text keeps each card's metadata block
        // a fixed height, which keeps card heights (and the image's top/bottom
        // edges) aligned across the grid even when names wrap differently.
        VStack(alignment: .leading, spacing: 3) {
            Text(product.brand)
                .coveredSmallCaps()
                .foregroundStyle(.coveredMuted)
                .lineLimit(1, reservesSpace: true)
            Text(product.name)
                .font(.coveredProductName)
                .foregroundStyle(.coveredInk)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 1)
            HStack(alignment: .firstTextBaseline, spacing: CoveredSpacing.sm) {
                Text(CoveredFormatters.priceText(product.priceRetail))
                    .font(.coveredBodyEmph)
                    .foregroundStyle(.coveredOlive)
                Text("Buy \(CoveredFormatters.priceText(product.priceBuyDiscount))")
                    .font(.coveredCaption)
                    .foregroundStyle(.coveredMuted)
            }
            .lineLimit(1, reservesSpace: true)
        }
        .padding(.horizontal, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: CoveredSpacing.md) {
        ForEach(MockData.PreviewData.sampleProducts.prefix(4)) { product in
            ProductCard(product: product, isSaved: false) {}
        }
    }
    .padding()
    .background(Color.coveredCream)
}
