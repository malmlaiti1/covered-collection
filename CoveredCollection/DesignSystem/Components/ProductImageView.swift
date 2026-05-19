import SwiftUI

struct ProductImageView: View {
    let product: Product
    var aspect: CGFloat = 3.0 / 4.0
    var cornerRadius: CGFloat = CoveredSpacing.cardCorner
    /// Larger variant used on the product-detail hero — adds a season label.
    var big: Bool = false
    var showsBrandLabel: Bool = true
    /// Optional variant seed — different values yield different procedural
    /// renderings (tone + sheen position) so a single product can be shown
    /// across a carousel as multiple "shots."
    var variantIndex: Int = 0

    var body: some View {
        // Use a transparent placeholder to lock the outer frame to the
        // requested aspect ratio. Without this, intrinsic image sizes can
        // cause cards in the closet grid to render at slightly different
        // heights when assets resolve at different times.
        Color.clear
            .aspectRatio(aspect, contentMode: .fit)
            .overlay(
                ZStack {
                    let imageToUse = loadImage()
                    if let imageToUse = imageToUse {
                        Image(uiImage: imageToUse)
                            .resizable()
                            .scaledToFill()
                    } else {
                        procedural
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .accessibilityLabel(Text("\(product.brand) — \(product.name)"))
    }

    private var procedural: some View {
        let tone = BrandTone.tone(forSeed: product.id.uuidString + "-\(variantIndex)")
        // Vary the highlight origin per variant so the carousel feels like
        // different shots of the same garment.
        let highlight: UnitPoint = {
            switch variantIndex % 3 {
            case 1: return UnitPoint(x: 0.70, y: 0.30)
            case 2: return UnitPoint(x: 0.50, y: 0.85)
            default: return UnitPoint(x: 0.30, y: 0.25)
            }
        }()
        return ZStack {
            // 1. Tone fabric drape gradient
            ToneGradient.make(base: tone.background)

            // 2. Subtle film grain
            NoiseOverlay()

            // 3. Radial highlight (position varies per variant)
            RadialGradient(
                colors: [Color.white.opacity(0.10), .clear],
                center: highlight,
                startRadius: 0,
                endRadius: 180
            )

            // 4. Diagonal sheen
            SheenOverlay()

            // 5. Garment silhouette glyph (very subtle, inherits from BrandTone foreground)
            silhouette
                .foregroundStyle(.white.opacity(0.18))

            // 6. Brand corner label (top-left) + optional season tag (top-right)
            if showsBrandLabel {
                VStack {
                    HStack(alignment: .top) {
                        Text(product.brand)
                            .font(.system(.caption2, design: .monospaced).weight(.medium))
                            .tracking(2.2)
                            .textCase(.uppercase)
                            .foregroundStyle(.white.opacity(0.92))
                            .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 1)
                        Spacer(minLength: CoveredSpacing.sm)
                        if big {
                            Text("SS · 26")
                                .font(.system(.caption2, design: .monospaced).weight(.medium))
                                .tracking(1.8)
                                .textCase(.uppercase)
                                .foregroundStyle(.white.opacity(0.78))
                        }
                    }
                    .padding(.horizontal, CoveredSpacing.sm)
                    .padding(.top, CoveredSpacing.sm)
                    Spacer()
                }
            }
        }
    }

    /// Load image with priority: dev-uploaded > asset catalog > nil
    private func loadImage() -> UIImage? {
        guard let asset = product.imageAssetName else { return nil }

        // Check Documents folder first (dev uploads)
        #if DEBUG
        let seed = asset.replacingOccurrences(of: "Products/", with: "")
        if let devImage = DevModeStore.shared.loadUploadedImage(for: seed) {
            return devImage
        }
        #endif

        // Fall back to asset catalog
        return UIImage(named: asset)
    }

    @ViewBuilder
    private var silhouette: some View {
        let symbol: String = {
            switch product.category {
            case .dresses:     return "figure.stand.dress"
            case .tops:        return "tshirt.fill"
            case .bottoms:     return "rectangle.portrait.fill"
            case .outerwear:   return "snowflake"
            case .accessories: return "handbag.fill"
            }
        }()
        Image(systemName: symbol)
            .font(.system(size: 64, weight: .ultraLight))
    }
}

#Preview {
    VStack {
        ProductImageView(product: MockData.PreviewData.sampleProduct, big: true)
            .frame(width: 220)
    }
    .padding()
    .background(Color.coveredCream)
}
