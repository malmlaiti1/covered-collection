import SwiftUI

struct PlansView: View {
    var plans: [SubscriptionPlan] = MockData.plans
    @Binding var selection: SubscriptionPlan?
    var primaryCTA: String = "Choose plan"
    var onContinue: (() -> Void)? = nil
    var showsTrustRow: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                header

                VStack(spacing: CoveredSpacing.md) {
                    ForEach(plans) { plan in
                        planCard(plan)
                    }
                }

                Text("Need just one occasion? Try our event rental.")
                    .font(.coveredCaption)
                    .foregroundStyle(.coveredMuted)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, CoveredSpacing.sm)

                if showsTrustRow {
                    trustRow
                        .padding(.top, CoveredSpacing.md)
                }

                if let onContinue {
                    CoveredButton(title: primaryCTA, kind: .primary) {
                        onContinue()
                    }
                    .disabled(selection == nil)
                    .opacity(selection == nil ? 0.45 : 1)
                    .padding(.top, CoveredSpacing.md)
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
            .padding(.vertical, CoveredSpacing.lg)
        }
        .background(Color.coveredCream.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("Choose your closet").font(.coveredDisplay).foregroundStyle(.coveredInk)
            Text("Pause, swap, or cancel anytime.")
                .font(.coveredBody).foregroundStyle(.coveredMuted)
        }
    }

    @ViewBuilder
    private func planCard(_ plan: SubscriptionPlan) -> some View {
        let isSelected = selection?.id == plan.id
        let strokeColor: Color = (plan.isFeatured || isSelected) ? Color.coveredOlive : Color.coveredBorder
        Button {
            selection = plan
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(plan.name)
                            .font(.system(size: 22, design: .serif).weight(.medium))
                            .foregroundStyle(.coveredInk)
                        Text(plan.tagline)
                            .font(.coveredCaption)
                            .foregroundStyle(.coveredMuted)
                    }
                    Spacer()
                    if plan.isFeatured {
                        Text("MOST POPULAR")
                            .font(.system(size: 10, weight: .semibold))
                            .tracking(0.5)
                            .foregroundStyle(.coveredCream)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.coveredOlive)
                            .clipShape(Capsule())
                    }
                }
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(CoveredFormatters.priceText(plan.pricePerMonth))
                        .font(.system(size: 28, design: .serif).weight(.medium))
                        .foregroundStyle(.coveredOlive)
                    Text("/mo")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredMuted)
                }
                .padding(.top, 2)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(plan.features, id: \.self) { feat in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.coveredSuccess)
                                .padding(.top, 3)
                            Text(feat)
                                .font(.coveredCaption)
                                .foregroundStyle(.coveredInk)
                            Spacer(minLength: 0)
                        }
                    }
                }

                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(isSelected ? Color.coveredOlive : Color.coveredMuted, lineWidth: 1.5)
                            .frame(width: 18, height: 18)
                        if isSelected {
                            Circle()
                                .fill(Color.coveredOlive)
                                .frame(width: 9, height: 9)
                        }
                    }
                    Text(isSelected ? "Selected" : "Tap to select")
                        .font(.coveredCaption)
                        .foregroundStyle(isSelected ? .coveredInk : .coveredMuted)
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.coveredSurface)
            .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous)
                    .stroke(strokeColor, lineWidth: 1.5)
            )
            .shadow(
                color: plan.isFeatured ? Color.coveredOlive.opacity(0.12) : Color.black.opacity(0.04),
                radius: plan.isFeatured ? 18 : 12,
                x: 0,
                y: plan.isFeatured ? 10 : 4
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint(isSelected ? "Selected" : "Double tap to select \(plan.name)")
    }

    private var trustRow: some View {
        HStack(spacing: CoveredSpacing.md) {
            trustItem(symbol: "arrow.uturn.backward.circle", text: "Cancel anytime")
            trustItem(symbol: "checkmark.shield.fill", text: "No damage fees")
            trustItem(symbol: "leaf.fill", text: "PERC-free cleaning")
        }
    }

    private func trustItem(symbol: String, text: String) -> some View {
        VStack(spacing: CoveredSpacing.xs) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.coveredOlive)
            Text(text)
                .font(.caption2)
                .foregroundStyle(.coveredMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

}

#Preview {
    StatefulPreviewWrapper(SubscriptionPlan?.none) { selection in
        PlansView(selection: selection, primaryCTA: "Continue") {}
    }
}

