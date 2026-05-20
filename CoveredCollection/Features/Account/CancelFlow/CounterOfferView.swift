import SwiftUI

struct CounterOfferView: View {
    let offer: CounterOffer
    let onAccept: () -> Void
    let onDecline: () -> Void

    @State private var selectedPauseDuration: Int?

    var body: some View {
        EmptyView()
    }

    // MARK: - Subviews

    private var header: some View { EmptyView() }

    private var offerCard: some View { EmptyView() }

    @ViewBuilder
    private var offerBody: some View { EmptyView() }

    private var discountedMonthBody: some View { EmptyView() }

    private var pauseBody: some View { EmptyView() }

    private var downgradeBody: some View { EmptyView() }

    private var actionButtons: some View { EmptyView() }

    // MARK: - Helpers

    private func selectPause(days: Int) {}
}
