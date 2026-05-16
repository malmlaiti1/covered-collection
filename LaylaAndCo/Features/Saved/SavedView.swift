import SwiftUI

struct SavedView: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(AppTabSelection.self) private var tabSelection
    @State private var path: [ClosetRoute] = []

    private let columns = [
        GridItem(.flexible(), spacing: LaylaSpacing.md),
        GridItem(.flexible(), spacing: LaylaSpacing.md)
    ]

    private var savedItems: [Product] {
        MockData.products.filter { store.profile.savedProducts.contains($0.id) }
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if savedItems.isEmpty {
                    emptyState
                } else {
                    grid
                }
            }
            .background(Color.laylaCream.ignoresSafeArea())
            .navigationTitle("Saved")
            .toolbarBackground(Color.laylaCream, for: .navigationBar)
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

    private var grid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LaylaSpacing.lg) {
                ForEach(savedItems) { product in
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
            .padding(LaylaSpacing.lg)
        }
    }
}

#Preview {
    SavedView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
