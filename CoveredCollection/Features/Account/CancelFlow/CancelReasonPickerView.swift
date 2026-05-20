import SwiftUI

struct CancelReasonPickerView: View {
    @Binding var selection: CancellationReason?
    let onContinue: () -> Void

    var body: some View {
        EmptyView()
    }

    // MARK: - Subviews

    private var header: some View { EmptyView() }

    private var reasonList: some View { EmptyView() }

    private var continueButton: some View { EmptyView() }

    // MARK: - Helpers

    private func select(_ reason: CancellationReason) {}
}
