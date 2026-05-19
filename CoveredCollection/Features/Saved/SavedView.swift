import SwiftUI

struct SavedView: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(AppTabSelection.self) private var tabSelection
    @State private var path: [ClosetRoute] = []
    @State private var filter: SavedFilter = .all

    private let columns = [
        GridItem(.flexible(), spacing: CoveredSpacing.md),
        GridItem(.flexible(), spacing: CoveredSpacing.md)
    ]

    private var savedItems: [Product] {
        MockData.products.filter { store.profile.savedProducts.contains($0.id) }
    }

    private var filteredItems: [Product] {
        switch filter {
        case .all: return savedItems
        case .dresses: return savedItems.filter { $0.category == .dresses }
        case .outerwear: return savedItems.filter { $0.category == .outerwear }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if savedItems.isEmpty {
                    emptyState
                } else {
                    contentList
                }
            }
            .background(Color.coveredCream.ignoresSafeArea())
            .navigationTitle("Saved")
            .toolbarBackground(Color.coveredCream, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: ClosetRoute.self) { route in
                if case .productDetail(let id) = route,
                   let p = MockData.products.first(where: { $0.id == id }) {
                    ProductDetailView(product: p)
                }
            }
        }
    }

    private var emptyState: some View {
        EmptyStateView(
            symbol: "heart",
            headline: "Nothing saved yet",
            message: "Heart pieces in your Closet to save them here.",
            ctaTitle: "Browse Closet"
        ) {
            tabSelection.selected = .closet
        }
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SavedFilter.allCases) { f in
                    Button { filter = f } label: {
                        CoveredTag(title: f.title(allCount: savedItems.count), isSelected: filter == f)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
        }
    }

    private var contentList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                filterRow
                    .padding(.top, 4)
                LazyVGrid(columns: columns, spacing: CoveredSpacing.lg) {
                    ForEach(filteredItems) { product in
                        Button {
                            path.append(.productDetail(product.id))
                        } label: {
                            ProductCard(product: product, isSaved: true) {
                                store.toggleSaved(product.id)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, CoveredSpacing.lg)
            }
            .padding(.bottom, CoveredSpacing.xl * 2)
        }
    }
}

private enum SavedFilter: String, CaseIterable, Identifiable {
    case all, dresses, outerwear
    var id: String { rawValue }

    func title(allCount: Int) -> String {
        switch self {
        case .all: return "All · \(allCount)"
        case .dresses: return "Dresses"
        case .outerwear: return "Outerwear"
        }
    }
}

#Preview {
    SavedView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
