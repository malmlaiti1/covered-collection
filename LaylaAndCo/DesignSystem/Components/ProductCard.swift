import SwiftUI

struct ProductCard: View {
    let product: Product
    var isSaved: Bool = false
    var onToggleSave: (() -> Void)? = nil

    private var priceText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = "USD"
        return formatter.string(from: product.priceRetail as NSDecimalNumber) ?? "—"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
            ZStack(alignment: .topTrailing) {
                ProductImageView(product: product)
                Button {
                    onToggleSave?()
                } label: {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(isSaved ? Color.laylaRose : Color.laylaInk)
                        .padding(8)
                        .background(Color.laylaSurface.opacity(0.92))
                        .clipShape(Circle())
                }
                .padding(LaylaSpacing.sm)
                .accessibilityLabel(isSaved ? "Remove from saved" : "Save")
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(product.brand)
                    .laylaSmallCaps()
                    .foregroundStyle(.laylaMuted)
                Text(product.name)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(.laylaInk)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text(priceText)
                    .font(.laylaCaption)
                    .foregroundStyle(.laylaOlive)
                    .padding(.top, 2)
            }
            ModestyDNABadgeRow(dna: product.modestyDNA, compact: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: LaylaSpacing.md) {
        ForEach(MockData.PreviewData.sampleProducts.prefix(4)) { product in
            ProductCard(product: product, isSaved: false) {}
        }
    }
    .padding()
    .background(Color.laylaCream)
}
