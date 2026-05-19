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
            VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                heroImage
                header
                matchCard
                sizePicker
                actions
                subscriberPhotos
                hijabPairings
                Spacer(minLength: CoveredSpacing.xl)
            }
            .padding(.horizontal, CoveredSpacing.lg)
        }
        .background(Color.coveredCream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.toggleSaved(product.id)
                } label: {
                    Image(systemName: store.profile.savedProducts.contains(product.id) ? "heart.fill" : "heart")
                        .foregroundStyle(.coveredInk)
                }
                .accessibilityLabel("Save")
            }
        }
    }

    private var heroImage: some View {
        ProductImageView(product: product, aspect: 4.0/5.0, cornerRadius: 16, big: true)
            .frame(maxHeight: 460)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.xs) {
            Text(product.brand).coveredSmallCaps().foregroundStyle(.coveredMuted)
            Text(product.name)
                .font(.coveredHeadline)
                .foregroundStyle(.coveredInk)
            HStack(spacing: CoveredSpacing.md) {
                Text(CoveredFormatters.priceText(product.priceRetail))
                    .font(.coveredBodyEmph)
                    .foregroundStyle(.coveredOlive)
                Text("Buy: \(CoveredFormatters.priceText(product.priceBuyDiscount))")
                    .font(.coveredCaption)
                    .foregroundStyle(.coveredMuted)
            }
        }
    }

    @ViewBuilder
    private var matchCard: some View {
        CoveredCard(background: .coveredTagBg, stroke: nil) {
            VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
                HStack(spacing: CoveredSpacing.sm) {
                    Image(systemName: matches ? "checkmark.seal.fill" : "exclamationmark.triangle")
                        .foregroundStyle(matches ? Color.coveredSuccess : Color.coveredRose)
                    Text(matches ? "Matches your Modesty DNA" : "Outside your default DNA")
                        .font(.coveredBodyEmph)
                        .foregroundStyle(.coveredInk)
                }
                Divider().background(Color.coveredBorder)
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
            Text(label).font(.coveredCaption).foregroundStyle(.coveredMuted)
            Spacer()
            Text(value).font(.coveredCaption).foregroundStyle(.coveredInk)
        }
    }

    private var sizePicker: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("Size").coveredSmallCaps().foregroundStyle(.coveredMuted)
            HStack(spacing: CoveredSpacing.sm) {
                ForEach(product.availableSizes) { size in
                    Button {
                        selectedSize = size
                    } label: {
                        Text(size.displayName)
                            .font(.coveredBodyEmph)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(selectedSize == size ? Color.coveredCream : Color.coveredInk)
                            .background(selectedSize == size ? Color.coveredOlive : Color.coveredSurface)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.coveredBorder, lineWidth: 1))
                    }
                    .accessibilityLabel("Size \(size.displayName)")
                }
            }
        }
    }

    private var actions: some View {
        VStack(spacing: CoveredSpacing.sm) {
            CoveredButton(
                title: didAdd ? "Added to Next Box ✓" : "Add to Next Box",
                kind: .primary
            ) {
                store.addToQueue(product.id)
                withAnimation { didAdd = true }
            }
            CoveredButton(title: "Reserve for an Event", kind: .secondary) {}
            CoveredButton(title: "Buy for \(CoveredFormatters.priceText(product.priceBuyDiscount))", kind: .textLink) {}
        }
    }

    private var subscriberPhotos: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("Real subscriber photos").coveredSmallCaps().foregroundStyle(.coveredMuted)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CoveredSpacing.md) {
                    ForEach(0..<6, id: \.self) { idx in
                        let tone = BrandTone.allCases[idx % BrandTone.allCases.count]
                        Circle()
                            .fill(ToneGradient.make(base: tone.background))
                            .frame(width: 72, height: 72)
                            .overlay(
                                Image(systemName: "person.2.fill")
                                    .font(.title3)
                                    .foregroundStyle(.white.opacity(0.85))
                            )
                            .overlay(Circle().stroke(Color.coveredCream, lineWidth: 1.5))
                            .shadow(color: Color(red: 0.18, green: 0.14, blue: 0.08).opacity(0.10),
                                    radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
    }

    private var hijabPairings: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("Style it with").coveredSmallCaps().foregroundStyle(.coveredMuted)
            let pairings = MockData.products.filter { $0.brand == "Haute Hijab" }.prefix(3)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CoveredSpacing.md) {
                    ForEach(Array(pairings)) { item in
                        VStack(alignment: .leading, spacing: CoveredSpacing.xs) {
                            ProductImageView(product: item, aspect: 1.0, cornerRadius: 12)
                                .frame(width: 124, height: 124)
                            Text(item.name)
                                .font(.coveredProductName)
                                .foregroundStyle(.coveredInk)
                                .frame(width: 124, alignment: .leading)
                                .lineLimit(2)
                            Text(CoveredFormatters.priceText(item.priceRetail))
                                .font(.coveredCaption)
                                .foregroundStyle(.coveredOlive)
                        }
                    }
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        ProductDetailView(product: MockData.PreviewData.sampleProduct)
    }
    .environment(UserProfileStore())
}
