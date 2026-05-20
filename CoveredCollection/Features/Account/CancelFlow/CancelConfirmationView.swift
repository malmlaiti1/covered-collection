import SwiftUI

struct CancelConfirmationView: View {
    let reason: CancellationReason?
    let onConfirm: () -> Void
    let onBack: () -> Void

    @State private var showFinalAlert = false

    var body: some View {
        EmptyView()
    }

    // MARK: - Subviews

    private var header: some View { EmptyView() }

    private var summaryCard: some View { EmptyView() }

    private var confirmButton: some View { EmptyView() }

    private var keepSubscriptionButton: some View { EmptyView() }

    // MARK: - Helpers

    private func presentFinalAlert() {}
}
