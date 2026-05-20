import SwiftUI

enum CancelFlowStep: Hashable {
    case reason
    case counterOffer
    case confirmation
}

struct CancelFlowView: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var path: [CancelFlowStep] = []
    @State private var selectedReason: CancellationReason?
    @State private var acceptedOffer: CounterOffer?

    var body: some View {
        EmptyView()
    }

    // MARK: - Navigation

    private func advanceToCounterOffer() {}

    private func advanceToConfirmation() {}

    private func dismissFlow() {}

    // MARK: - Actions

    private func acceptCurrentOffer() {}

    private func confirmCancellation() {}

    // MARK: - Offer resolution

    private func counterOffer(for reason: CancellationReason) -> CounterOffer { .downgradeToCore }
}
