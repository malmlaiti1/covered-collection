import SwiftUI

struct EmptyStateView: View {
    let symbol: String
    let headline: String
    let message: String
    let ctaTitle: String
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: CoveredSpacing.md) {
            Image(systemName: symbol)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.coveredOlive)
                .padding(.top, CoveredSpacing.xl)
            Text(headline)
                .font(.coveredHeadline)
                .foregroundStyle(.coveredInk)
            Text(message)
                .font(.coveredBody)
                .foregroundStyle(.coveredMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, CoveredSpacing.xl)
            CoveredButton(title: ctaTitle, kind: .primary, isFullWidth: false) {
                onTap()
            }
            .padding(.top, CoveredSpacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CoveredSpacing.xl)
    }
}
