import SwiftUI

struct MyBoxView: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(AppTabSelection.self) private var tabSelection
    @State private var path: [MyBoxRoute] = []
    @State private var showPlansSheet = false

    var body: some View {
        NavigationStack(path: $path) {
            content
                .background(Color.laylaCream.ignoresSafeArea())
                .navigationTitle("My Box")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color.laylaCream, for: .navigationBar)
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

    private var preSubscriptionEmpty: some View {
        EmptyStateView(
            symbol: "shippingbox",
            headline: "Your first box is waiting",
            message: "Choose a plan to start your wardrobe rotation.",
            ctaTitle: "View Plans"
        ) {
            showPlansSheet = true
        }
    }

    private var betweenShipmentsEmpty: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
            EmptyStateView(
                symbol: "calendar",
                headline: "Next box ships soon",
                message: "We're preparing your next shipment. Manage your queue below.",
                ctaTitle: "Edit my queue"
            ) {
                path.append(.buildNext)
            }
            if !store.profile.queue.isEmpty {
                Text("In your queue").laylaSmallCaps().foregroundStyle(.laylaMuted)
                    .padding(.horizontal, LaylaSpacing.lg)
                ForEach(MockData.products.filter { store.profile.queue.contains($0.id) }) { item in
                    BoxItemRow(product: item, isShipping: false)
                        .padding(.horizontal, LaylaSpacing.lg)
                }
            }
        }
    }

    private var activeBox: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                trackerStrip
                Text("Your November Box")
                    .font(.laylaHeadline)
                    .foregroundStyle(.laylaInk)
                    .padding(.horizontal, LaylaSpacing.lg)

                ForEach(currentBoxItems) { item in
                    BoxItemRow(product: item, isShipping: true)
                        .padding(.horizontal, LaylaSpacing.lg)
                }

                buildNextCard
                    .padding(.horizontal, LaylaSpacing.lg)
                    .padding(.top, LaylaSpacing.md)
            }
            .padding(.vertical, LaylaSpacing.lg)
        }
    }

    private var currentBoxItems: [Product] {
        MockData.products.filter { store.profile.currentBox.contains($0.id) }
    }

    private var trackerStrip: some View {
        let steps = ["Packed", "Shipped", "Out for delivery", "Delivered"]
        let currentIdx = 2
        return HStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { idx in
                VStack(spacing: LaylaSpacing.sm) {
                    Circle()
                        .fill(idx <= currentIdx ? Color.laylaOlive : Color.laylaBorder)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle().stroke(Color.laylaCream, lineWidth: 2)
                        )
                    Text(steps[idx])
                        .font(.caption2)
                        .foregroundStyle(idx <= currentIdx ? .laylaInk : .laylaMuted)
                }
                if idx < steps.count - 1 {
                    Rectangle()
                        .fill(idx < currentIdx ? Color.laylaOlive : Color.laylaBorder)
                        .frame(height: 2)
                        .padding(.bottom, 20)
                }
            }
        }
        .padding(.horizontal, LaylaSpacing.lg)
    }

    private var buildNextCard: some View {
        Button {
            path.append(.buildNext)
        } label: {
            LaylaCard {
                HStack {
                    VStack(alignment: .leading, spacing: LaylaSpacing.xs) {
                        Text("Build your next box")
                            .font(.laylaTitle).foregroundStyle(.laylaInk)
                        Text("Tap to start curating.")
                            .font(.laylaCaption).foregroundStyle(.laylaMuted)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.laylaOlive)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct BoxItemRow: View {
    let product: Product
    let isShipping: Bool

    var body: some View {
        HStack(spacing: LaylaSpacing.md) {
            ProductImageView(product: product, aspect: 1.0, cornerRadius: 10)
                .frame(width: 76, height: 76)

            VStack(alignment: .leading, spacing: 2) {
                Text(product.brand).laylaSmallCaps().foregroundStyle(.laylaMuted)
                Text(product.name)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(.laylaInk)
                    .lineLimit(2)
                Text("Size M").font(.caption2).foregroundStyle(.laylaMuted)
            }

            Spacer()

            if isShipping {
                VStack(spacing: 6) {
                    miniButton("Buy")
                    miniButton("Keep")
                    miniButton("Send back")
                }
            }
        }
        .padding(LaylaSpacing.md)
        .background(Color.laylaSurface)
        .clipShape(RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner)
                .stroke(Color.laylaBorder, lineWidth: 1)
        )
    }

    private func miniButton(_ title: String) -> some View {
        Text(title)
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(.laylaOlive)
            .background(Color.laylaTagBg)
            .clipShape(Capsule())
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

struct EmptyStateView: View {
    let symbol: String
    let headline: String
    let message: String
    let ctaTitle: String
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: LaylaSpacing.md) {
            Image(systemName: symbol)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.laylaOlive)
                .padding(.top, LaylaSpacing.xl)
            Text(headline)
                .font(.laylaHeadline)
                .foregroundStyle(.laylaInk)
            Text(message)
                .font(.laylaBody)
                .foregroundStyle(.laylaMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, LaylaSpacing.xl)
            LaylaButton(title: ctaTitle, kind: .primary, isFullWidth: false) {
                onTap()
            }
            .padding(.top, LaylaSpacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, LaylaSpacing.xl)
    }
}

#Preview("Pre-sub") {
    MyBoxView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
