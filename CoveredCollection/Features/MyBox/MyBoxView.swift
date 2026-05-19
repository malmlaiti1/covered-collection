import SwiftUI

struct MyBoxView: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(AppTabSelection.self) private var tabSelection
    @State private var path: [MyBoxRoute] = []
    @State private var showPlansSheet = false

    var body: some View {
        NavigationStack(path: $path) {
            content
                .background(Color.coveredCream.ignoresSafeArea())
                .navigationTitle("My Box")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "plus")
                            .foregroundStyle(.coveredInk)
                            .accessibilityLabel("Add to box")
                    }
                }
                .toolbarBackground(Color.coveredCream, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationDestination(for: MyBoxRoute.self) { route in
                    switch route {
                    case .itemDetail(let id):
                        if let p = MockData.products.first(where: { $0.id == id }) {
                            ProductDetailView(product: p)
                        }
                    case .buildNext:
                        Text("Build your next box").padding()
                    }
                }
                .sheet(isPresented: $showPlansSheet) {
                    NavigationStack {
                        PlansPickerSheet()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.profile.currentPlan == nil {
            preSubscriptionEmpty
        } else if store.profile.currentBox.isEmpty {
            betweenShipmentsEmpty
        } else {
            activeBox
        }
    }

    // MARK: - Pre-subscription
    //
    // Replaces the generic empty state with a still-life of a paper-wrapped
    // gift box on a warm oat→sand gradient — matches the design's MyBoxPreSub.

    private var preSubscriptionEmpty: some View {
        ScrollView {
            VStack(alignment: .center, spacing: CoveredSpacing.lg) {
                PaperBoxIllustration()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal, CoveredSpacing.lg)

                VStack(spacing: CoveredSpacing.sm) {
                    Text("Your first box\nis waiting.")
                        .font(.coveredDisplay)
                        .foregroundStyle(.coveredInk)
                        .multilineTextAlignment(.center)
                    Text("Choose a plan to start your wardrobe rotation. Pause or cancel anytime.")
                        .font(.coveredBody)
                        .foregroundStyle(.coveredMuted)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }

                VStack(spacing: CoveredSpacing.sm) {
                    CoveredButton(title: "Choose a plan", kind: .primary) {
                        showPlansSheet = true
                    }
                    CoveredButton(title: "Learn how it works", kind: .textLink) {}
                }
                .padding(.horizontal, CoveredSpacing.lg)
            }
            .padding(.vertical, CoveredSpacing.lg)
        }
    }

    private var betweenShipmentsEmpty: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
            EmptyStateView(
                symbol: "calendar",
                headline: "Next box ships soon",
                message: "We're preparing your next shipment. Manage your queue below.",
                ctaTitle: "Edit my queue"
            ) {
                path.append(.buildNext)
            }
            if !store.profile.queue.isEmpty {
                Text("In your queue").coveredSmallCaps().foregroundStyle(.coveredMuted)
                    .padding(.horizontal, CoveredSpacing.lg)
                ForEach(MockData.products.filter { store.profile.queue.contains($0.id) }) { item in
                    BoxItemRow(product: item, isShipping: false)
                        .padding(.horizontal, CoveredSpacing.lg)
                }
            }
        }
    }

    // MARK: - Active

    private var activeBox: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                etaStrip
                    .padding(.horizontal, CoveredSpacing.lg)

                Text(currentBoxTitle)
                    .font(.coveredHeadline)
                    .foregroundStyle(.coveredInk)
                    .padding(.horizontal, CoveredSpacing.lg)

                VStack(spacing: CoveredSpacing.sm) {
                    ForEach(currentBoxItems) { item in
                        BoxItemRow(product: item, isShipping: true)
                    }
                }
                .padding(.horizontal, CoveredSpacing.lg)

                buildNextCard
                    .padding(.horizontal, CoveredSpacing.lg)
                    .padding(.top, CoveredSpacing.sm)

                queueSection
                    .padding(.horizontal, CoveredSpacing.lg)
                    .padding(.top, CoveredSpacing.md)
            }
            .padding(.vertical, CoveredSpacing.lg)
        }
    }

    private var currentBoxTitle: String {
        let monthName = Date.now.formatted(.dateTime.month(.wide))
        return "Your \(monthName) Box"
    }

    private var currentBoxItems: [Product] {
        MockData.products.filter { store.profile.currentBox.contains($0.id) }
    }

    private var etaStrip: some View {
        CoveredCard {
            VStack(spacing: CoveredSpacing.md) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Arriving").coveredSmallCaps().foregroundStyle(.coveredMuted)
                        Text(etaText)
                            .font(.coveredTitle)
                            .foregroundStyle(.coveredInk)
                    }
                    Spacer()
                    Text("USPS · 9405…")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredOlive)
                }
                trackerStrip
            }
        }
    }

    private var etaText: String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
        let formatted = tomorrow.formatted(.dateTime.month(.abbreviated).day())
        return "Tomorrow · \(formatted)"
    }

    private var trackerStrip: some View {
        let steps = ["Packed", "Shipped", "Out for delivery", "Delivered"]
        let currentIdx = 2
        return HStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { idx in
                VStack(spacing: CoveredSpacing.sm) {
                    Circle()
                        .fill(idx <= currentIdx ? Color.coveredOlive : Color.coveredBorder)
                        .frame(width: 16, height: 16)
                        .overlay(Circle().stroke(Color.coveredCream, lineWidth: 3))
                    Text(steps[idx])
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(idx <= currentIdx ? .coveredInk : .coveredMuted)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 64)
                }
                if idx < steps.count - 1 {
                    Rectangle()
                        .fill(idx < currentIdx ? Color.coveredOlive : Color.coveredBorder)
                        .frame(height: 2)
                        .padding(.bottom, 20)
                }
            }
        }
    }

    private var buildNextCard: some View {
        Button {
            path.append(.buildNext)
        } label: {
            ZStack {
                LinearGradient(
                    colors: [Color.coveredSurface, Color.coveredTagBg],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Build your next box")
                            .font(.coveredTitle).foregroundStyle(.coveredInk)
                        Text("5 of 5 slots open · ships next month")
                            .font(.coveredCaption).foregroundStyle(.coveredMuted)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.coveredCream)
                        .frame(width: 36, height: 36)
                        .background(Color.coveredOlive)
                        .clipShape(Circle())
                }
                .padding(CoveredSpacing.md)
            }
            .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous)
                    .stroke(Color.coveredBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var queueSection: some View {
        let queueItems = MockData.products.filter { store.profile.queue.contains($0.id) }
        if !queueItems.isEmpty {
            VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
                HStack {
                    Text("In your queue · \(queueItems.count)")
                        .coveredSmallCaps()
                        .foregroundStyle(.coveredMuted)
                    Spacer()
                    Text("Edit")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredOlive)
                }
                let columns = Array(repeating: GridItem(.flexible(), spacing: CoveredSpacing.sm), count: 4)
                LazyVGrid(columns: columns, spacing: CoveredSpacing.sm) {
                    ForEach(queueItems.prefix(8)) { p in
                        ProductImageView(product: p, aspect: 4.0/5.0, cornerRadius: 10, showsBrandLabel: false)
                    }
                }
            }
        }
    }
}

// MARK: - Box item row
//
// Used in the active box list: thumbnail, brand/name/size, three action pills.

private struct BoxItemRow: View {
    let product: Product
    let isShipping: Bool

    var body: some View {
        HStack(spacing: CoveredSpacing.md) {
            ProductImageView(product: product, aspect: 1.0, cornerRadius: 10, showsBrandLabel: false)
                .frame(width: 76, height: 76)

            VStack(alignment: .leading, spacing: 2) {
                Text(product.brand).coveredSmallCaps().foregroundStyle(.coveredMuted)
                Text(product.name)
                    .font(.coveredProductName)
                    .foregroundStyle(.coveredInk)
                    .lineLimit(2)
                Text("Size M").font(.caption2).foregroundStyle(.coveredMuted)
            }

            Spacer()

            if isShipping {
                VStack(spacing: 5) {
                    miniButton("Buy", solid: true)
                    miniButton("Keep")
                    miniButton("Send back")
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(CoveredSpacing.md)
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
    }

    private func miniButton(_ title: String, solid: Bool = false) -> some View {
        Text(title)
            .font(.system(size: 10.5, weight: .medium))
            .padding(.horizontal, 11)
            .padding(.vertical, 5)
            .foregroundStyle(solid ? Color.coveredCream : Color.coveredOlive)
            .background(solid ? Color.coveredOlive : Color.coveredTagBg)
            .clipShape(Capsule())
    }
}

// MARK: - Paper-wrapped box illustration
//
// Reproduces the SVG still-life from the design: cream box on warm oat→sand
// background, dusty-rose ribbon and bow, monogrammed "CC".

private struct PaperBoxIllustration: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.91, green: 0.86, blue: 0.76),  // oat #E8DBC2
                    Color(red: 0.78, green: 0.66, blue: 0.49),  // sand #C7A87D
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            NoiseOverlay(opacity: 0.05)

            GeometryReader { geo in
                let unit = min(geo.size.width, geo.size.height) / 200.0
                let originX = (geo.size.width  - 200 * unit) / 2
                let originY = (geo.size.height - 200 * unit) / 2

                ZStack {
                    // Box body
                    Path { p in
                        p.addRoundedRect(
                            in: CGRect(x: 50, y: 80, width: 100, height: 80),
                            cornerSize: CGSize(width: 3, height: 3)
                        )
                    }
                    .fill(
                        LinearGradient(
                            colors: [Color.coveredCream, Color.coveredBorder],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .overlay(
                        Path { p in
                            p.addRoundedRect(
                                in: CGRect(x: 50, y: 80, width: 100, height: 80),
                                cornerSize: CGSize(width: 3, height: 3)
                            )
                        }
                        .stroke(Color(red: 0.612, green: 0.545, blue: 0.42), lineWidth: 0.8)
                    )

                    // Box lid (slightly proud of the body)
                    Path { p in
                        p.addRoundedRect(
                            in: CGRect(x: 50, y: 74, width: 100, height: 14),
                            cornerSize: CGSize(width: 2, height: 2)
                        )
                    }
                    .fill(Color.coveredCream)
                    .overlay(
                        Path { p in
                            p.addRoundedRect(
                                in: CGRect(x: 50, y: 74, width: 100, height: 14),
                                cornerSize: CGSize(width: 2, height: 2)
                            )
                        }
                        .stroke(Color(red: 0.612, green: 0.545, blue: 0.42), lineWidth: 0.8)
                    )

                    // Vertical ribbon (dusty rose at 85% opacity)
                    Path { p in
                        p.addRect(CGRect(x: 92, y: 60, width: 16, height: 100))
                    }
                    .fill(Color.coveredRose.opacity(0.85))

                    // Bow — two looped halves
                    Path { p in
                        p.move(to: CGPoint(x: 100, y: 60))
                        p.addCurve(to: CGPoint(x: 84, y: 62),
                                   control1: CGPoint(x: 92, y: 52),
                                   control2: CGPoint(x: 80, y: 50))
                        p.addCurve(to: CGPoint(x: 100, y: 60),
                                   control1: CGPoint(x: 88, y: 72),
                                   control2: CGPoint(x: 100, y: 60))
                    }
                    .fill(Color.coveredRose)
                    Path { p in
                        p.move(to: CGPoint(x: 100, y: 60))
                        p.addCurve(to: CGPoint(x: 116, y: 62),
                                   control1: CGPoint(x: 108, y: 52),
                                   control2: CGPoint(x: 120, y: 50))
                        p.addCurve(to: CGPoint(x: 100, y: 60),
                                   control1: CGPoint(x: 112, y: 72),
                                   control2: CGPoint(x: 100, y: 60))
                    }
                    .fill(Color.coveredRose)

                    // Monogram
                    Text("CC")
                        .font(.system(size: 9, design: .serif).weight(.medium))
                        .tracking(2)
                        .foregroundStyle(.coveredOlive)
                        .position(x: 100, y: 125)
                }
                .frame(width: 200, height: 200, alignment: .topLeading)
                .scaleEffect(unit, anchor: .topLeading)
                .offset(x: originX, y: originY)
            }
        }
    }
}

private struct PlansPickerSheet: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selection: SubscriptionPlan? = nil

    var body: some View {
        PlansView(
            selection: $selection,
            primaryCTA: "Start subscription"
        ) {
            if let plan = selection {
                store.setCurrentPlan(plan)
                dismiss()
            }
        }
        .navigationTitle("Choose plan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") { dismiss() }
            }
        }
    }
}

#Preview("Pre-sub") {
    MyBoxView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
