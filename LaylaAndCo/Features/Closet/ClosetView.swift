import SwiftUI

struct ClosetView: View {
    @Environment(UserProfileStore.self) private var store
    @State private var vm = ClosetViewModel()
    @State private var path: [ClosetRoute] = []

    private let gridColumns = [
        GridItem(.flexible(), spacing: LaylaSpacing.md),
        GridItem(.flexible(), spacing: LaylaSpacing.md)
    ]

    var body: some View {
        @Bindable var vm = vm
        return NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                    filterPills
                    heroBanner
                    sectionHeader
                    grid
                }
                .padding(.bottom, LaylaSpacing.xl)
            }
            .background(Color.laylaCream.ignoresSafeArea())
            .navigationTitle("Layla & Co.")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Layla & Co.")
                        .font(.system(.headline, design: .serif).weight(.medium))
                        .foregroundStyle(.laylaInk)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: LaylaSpacing.md) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.laylaInk)
                        Menu {
                            Toggle("Respect Modesty DNA", isOn: $vm.respectDNA)
                            Section("Loosen sleeve to…") {
                                Button("Long (default)")  { vm.sleeveOverride = nil }
                                Button("Three-quarter")   { vm.sleeveOverride = .threeQuarter }
                                Button("Elbow OK")        { vm.sleeveOverride = .elbow }
                                Button("Short OK")        { vm.sleeveOverride = .short }
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.laylaInk)
                        }
                    }
                }
            }
            .toolbarBackground(Color.laylaCream, for: .navigationBar)
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
                        .font(.laylaTitle)
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
            HStack(spacing: LaylaSpacing.sm) {
                LaylaTag(title: "All", isSelected: vm.selectedFilter == nil)
                    .onTapGesture { vm.selectedFilter = nil }
                ForEach(ProductCategory.allCases) { cat in
                    LaylaTag(
                        title: cat.displayName,
                        systemImage: cat.symbol,
                        isSelected: vm.selectedFilter == cat
                    )
                    .onTapGesture {
                        vm.selectedFilter = (vm.selectedFilter == cat) ? nil : cat
                    }
                }
            }
            .padding(.horizontal, LaylaSpacing.lg)
        }
    }

    private var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.laylaGold, Color.laylaRose],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
                LaylaBadge(title: "Edit", background: .laylaCream, foreground: .laylaInk)
                Text("Ramadan 2027 Collection")
                    .font(.laylaDisplay)
                    .foregroundStyle(.laylaCream)
                Text("Curated for the month — gowns, abayas, and elevated everyday.")
                    .font(.laylaBody)
                    .foregroundStyle(Color.laylaCream.opacity(0.9))
                    .multilineTextAlignment(.leading)
            }
            .padding(LaylaSpacing.lg)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous))
        .padding(.horizontal, LaylaSpacing.lg)
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Curated for \(store.profile.firstName)")
                .font(.laylaHeadline)
                .foregroundStyle(.laylaInk)
            Text("Based on your Modesty DNA")
                .font(.laylaCaption)
                .foregroundStyle(.laylaMuted)
        }
        .padding(.horizontal, LaylaSpacing.lg)
    }

    @ViewBuilder
    private var grid: some View {
        let items = vm.filtered(for: store.profile.modestyDNA)
        if vm.isLoading {
            LazyVGrid(columns: gridColumns, spacing: LaylaSpacing.lg) {
                ForEach(MockData.products.prefix(4)) { product in
                    ProductCard(product: product, isSaved: false) {}
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.horizontal, LaylaSpacing.lg)
        } else if items.isEmpty {
            VStack(spacing: LaylaSpacing.md) {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle).foregroundStyle(.laylaMuted)
                Text("Nothing matches yet.")
                    .font(.laylaTitle).foregroundStyle(.laylaInk)
                Text("Try loosening a filter from the slider in the top right.")
                    .font(.laylaCaption).foregroundStyle(.laylaMuted)
                    .multilineTextAlignment(.center)
            }
            .padding(LaylaSpacing.lg)
            .frame(maxWidth: .infinity)
        } else {
            LazyVGrid(columns: gridColumns, spacing: LaylaSpacing.lg) {
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
            .padding(.horizontal, LaylaSpacing.lg)
        }
    }
}

#Preview {
    ClosetView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
