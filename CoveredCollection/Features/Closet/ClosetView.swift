import SwiftUI

struct ClosetView: View {
    @Environment(UserProfileStore.self) private var store
    @State private var vm = ClosetViewModel()
    @State private var path: [ClosetRoute] = []
    @AppStorage("closetCardSize") private var cardSizeRaw: String = CardSize.medium.rawValue

    private var cardSize: CardSize {
        CardSize(rawValue: cardSizeRaw) ?? .medium
    }

    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: CoveredSpacing.md),
            count: cardSize.columns
        )
    }

    var body: some View {
        @Bindable var vm = vm
        return NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                    filterPills
                    heroBanner
                    sectionHeader
                    grid
                }
                .padding(.bottom, CoveredSpacing.xl)
            }
            .background(Color.coveredCream.ignoresSafeArea())
            .navigationTitle("The Covered Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("The Covered Collection")
                        .font(.system(.headline, design: .serif).weight(.medium))
                        .foregroundStyle(.coveredInk)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: CoveredSpacing.md) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.coveredInk)
                        Menu {
                            Section("Card size") {
                                ForEach(CardSize.allCases) { size in
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.22)) {
                                            cardSizeRaw = size.rawValue
                                        }
                                    } label: {
                                        Label(size.displayName, systemImage: size.symbol)
                                        if size == cardSize {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                            Toggle("Respect Modesty DNA", isOn: $vm.respectDNA)
                            Section("Loosen sleeve to…") {
                                Button("Long (default)")  { vm.sleeveOverride = nil }
                                Button("Three-quarter")   { vm.sleeveOverride = .threeQuarter }
                                Button("Elbow OK")        { vm.sleeveOverride = .elbow }
                                Button("Short OK")        { vm.sleeveOverride = .short }
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.coveredInk)
                        }
                    }
                }
            }
            .toolbarBackground(Color.coveredCream, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: ClosetRoute.self) { route in
                switch route {
                case .productDetail(let id):
                    if let product = vm.allProducts.first(where: { $0.id == id }) {
                        ProductDetailView(product: product)
                    } else {
                        Text("Not found").padding()
                    }
                case .filteredEdit(let name):
                    Text("Filtered edit: \(name)")
                        .font(.coveredTitle)
                        .padding()
                }
            }
            .task {
                if vm.allProducts.isEmpty {
                    await vm.load()
                }
            }
        }
    }

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CoveredSpacing.sm) {
                CoveredTag(title: "All", isSelected: vm.selectedFilter == nil)
                    .onTapGesture { vm.selectedFilter = nil }
                ForEach(ProductCategory.allCases) { cat in
                    CoveredTag(
                        title: cat.displayName,
                        systemImage: cat.symbol,
                        isSelected: vm.selectedFilter == cat
                    )
                    .onTapGesture {
                        vm.selectedFilter = (vm.selectedFilter == cat) ? nil : cat
                    }
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
        }
    }

    private var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            // Base gradient — brass into dusty rose into a darker rose stop.
            LinearGradient(
                colors: [
                    Color.coveredGold,
                    Color.coveredRose,
                    Color.coveredRose.darkened(by: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Soft radial highlight upper-left.
            RadialGradient(
                colors: [Color.white.opacity(0.18), .clear],
                center: UnitPoint(x: 0.30, y: 0.25),
                startRadius: 0,
                endRadius: 180
            )

            // Subtle film grain to keep the surface from looking plastic.
            NoiseOverlay(opacity: 0.05)

            // Faint dress silhouette tucked into the right edge.
            HStack {
                Spacer()
                Image(systemName: "figure.stand.dress")
                    .font(.system(size: 180, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.18))
                    .offset(x: 20, y: 10)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
                CoveredBadge(title: "The Edit · Mar 26", background: .coveredCream, foreground: .coveredInk)
                Text("Ramadan 2027\nCollection")
                    .font(.coveredDisplay)
                    .foregroundStyle(.coveredCream)
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 1)
                Text("Curated for the month — gowns, abayas, and elevated everyday.")
                    .font(.coveredCaption)
                    .foregroundStyle(Color.coveredCream.opacity(0.92))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 230, alignment: .leading)
            }
            .padding(CoveredSpacing.lg)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal, CoveredSpacing.lg)
        .shadow(color: Color(red: 0.18, green: 0.14, blue: 0.08).opacity(0.16), radius: 14, x: 0, y: 12)
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Curated for \(store.profile.firstName)")
                .font(.coveredHeadline)
                .foregroundStyle(.coveredInk)
            Text("Based on your Modesty DNA · \(matchCount) matches")
                .font(.coveredCaption)
                .foregroundStyle(.coveredMuted)
        }
        .padding(.horizontal, CoveredSpacing.lg)
    }

    private var matchCount: Int {
        // Show a stable, evocative count rather than the raw mock list size.
        max(vm.filtered(for: store.profile.modestyDNA).count * 6, 36)
    }

    @ViewBuilder
    private var grid: some View {
        let items = vm.filtered(for: store.profile.modestyDNA)
        if vm.isLoading {
            LazyVGrid(columns: gridColumns, spacing: CoveredSpacing.lg) {
                ForEach(MockData.products.prefix(4)) { product in
                    ProductCard(product: product, isSaved: false) {}
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
        } else if items.isEmpty {
            VStack(spacing: CoveredSpacing.md) {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle).foregroundStyle(.coveredMuted)
                Text("Nothing matches yet.")
                    .font(.coveredTitle).foregroundStyle(.coveredInk)
                Text("Try loosening a filter from the slider in the top right.")
                    .font(.coveredCaption).foregroundStyle(.coveredMuted)
                    .multilineTextAlignment(.center)
            }
            .padding(CoveredSpacing.lg)
            .frame(maxWidth: .infinity)
        } else {
            LazyVGrid(columns: gridColumns, spacing: CoveredSpacing.lg) {
                ForEach(items) { product in
                    Button {
                        path.append(.productDetail(product.id))
                    } label: {
                        ProductCard(
                            product: product,
                            isSaved: store.profile.savedProducts.contains(product.id)
                        ) {
                            store.toggleSaved(product.id)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
        }
    }
}

#Preview {
    ClosetView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
