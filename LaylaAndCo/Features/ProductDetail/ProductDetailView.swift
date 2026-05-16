import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(UserProfileStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSize: Size = .m
    @State private var didAdd: Bool = false

    private var matches: Bool {
        store.profile.modestyDNA.matches(product: product.modestyDNA)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                heroImage
                header
                matchCard
                sizePicker
                actions
                subscriberPhotos
                hijabPairings
                Spacer(minLength: LaylaSpacing.xl)
            }
            .padding(.horizontal, LaylaSpacing.lg)
        }
        .background(Color.laylaCream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.toggleSaved(product.id)
                } label: {
                    Image(systemName: store.profile.savedProducts.contains(product.id) ? "heart.fill" : "heart")
                        .foregroundStyle(.laylaInk)
                }
                .accessibilityLabel("Save")
            }
        }
    }

    private var heroImage: some View {
        ProductImageView(product: product, aspect: 4.0/5.0, cornerRadius: LaylaSpacing.cardCorner)
            .frame(maxHeight: 460)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.xs) {
            Text(product.brand).laylaSmallCaps().foregroundStyle(.laylaMuted)
            Text(product.name)
                .font(.laylaHeadline)
                .foregroundStyle(.laylaInk)
            HStack(spacing: LaylaSpacing.md) {
                Text(priceText(product.priceRetail))
                    .font(.laylaBodyEmph)
                    .foregroundStyle(.laylaOlive)
                Text("Buy: \(priceText(product.priceBuyDiscount))")
                    .font(.laylaCaption)
                    .foregroundStyle(.laylaMuted)
            }
        }
    }

    @ViewBuilder
    private var matchCard: some View {
        LaylaCard(background: .laylaTagBg, stroke: nil) {
            VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
                HStack(spacing: LaylaSpacing.sm) {
                    Image(systemName: matches ? "checkmark.seal.fill" : "exclamationmark.triangle")
                        .foregroundStyle(matches ? Color.laylaSuccess : Color.laylaRose)
                    Text(matches ? "Matches your Modesty DNA" : "Outside your default DNA")
                        .font(.laylaBodyEmph)
                        .foregroundStyle(.laylaInk)
                }
                Divider().background(Color.laylaBorder)
                axisRow("Neckline", product.modestyDNA.neckline.displayName)
                axisRow("Sleeve",  product.modestyDNA.sleeve.displayName)
                axisRow("Hem",     product.modestyDNA.hem.displayName)
                axisRow("Opacity", product.modestyDNA.opacity.displayName)
                axisRow("Silhouette", product.modestyDNA.silhouette.displayName)
            }
        }
    }

    private func axisRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.laylaCaption).foregroundStyle(.laylaMuted)
            Spacer()
            Text(value).font(.laylaCaption).foregroundStyle(.laylaInk)
        }
    }

    private var sizePicker: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
            Text("Size").laylaSmallCaps().foregroundStyle(.laylaMuted)
            HStack(spacing: LaylaSpacing.sm) {
                ForEach(product.availableSizes) { size in
                    Button {
                        selectedSize = size
                    } label: {
                        Text(size.displayName)
                            .font(.laylaBodyEmph)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(selectedSize == size ? Color.laylaCream : Color.laylaInk)
                            .background(selectedSize == size ? Color.laylaOlive : Color.laylaSurface)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.laylaBorder, lineWidth: 1))
                    }
                    .accessibilityLabel("Size \(size.displayName)")
                }
            }
        }
    }

    private var actions: some View {
        VStack(spacing: LaylaSpacing.sm) {
            LaylaButton(
                title: didAdd ? "Added to Next Box ✓" : "Add to Next Box",
                kind: .primary
            ) {
                store.addToQueue(product.id)
                withAnimation { didAdd = true }
            }
            LaylaButton(title: "Reserve for an Event", kind: .secondary) {}
            LaylaButton(title: "Buy for \(priceText(product.priceBuyDiscount))", kind: .textLink) {}
        }
    }

    private var subscriberPhotos: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
            Text("Real subscriber photos").laylaSmallCaps().foregroundStyle(.laylaMuted)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: LaylaSpacing.md) {
                    ForEach(0..<6, id: \.self) { idx in
                        Circle()
                            .fill(BrandTone.allCases[idx % BrandTone.allCases.count].background)
                            .frame(width: 72, height: 72)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundStyle(.laylaCream.opacity(0.85))
                            )
                    }
                }
            }
        }
    }

    private var hijabPairings: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
            Text("Style it with").laylaSmallCaps().foregroundStyle(.laylaMuted)
            let pairings = MockData.products.filter { $0.brand == "Haute Hijab" }.prefix(3)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: LaylaSpacing.md) {
                    ForEach(Array(pairings)) { item in
                        VStack(alignment: .leading, spacing: LaylaSpacing.xs) {
                            ProductImageView(product: item, aspect: 1.0)
                                .frame(width: 120, height: 120)
                            Text(item.name)
                                .font(.laylaCaption)
                                .foregroundStyle(.laylaInk)
                                .frame(width: 120, alignment: .leading)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
    }

    private func priceText(_ d: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 0
        return f.string(from: d as NSDecimalNumber) ?? "$\(d)"
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: MockData.PreviewData.sampleProduct)
    }
    .environment(UserProfileStore())
}
