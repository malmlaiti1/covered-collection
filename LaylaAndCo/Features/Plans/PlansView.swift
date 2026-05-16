import SwiftUI

/// Reusable subscription-plan picker. Used in two places:
///   1. The onboarding flow (binding drives the next-step decision).
///   2. The Account tab's "Change plan" entry.
struct PlansView: View {
    var plans: [SubscriptionPlan] = MockData.plans
    @Binding var selection: SubscriptionPlan?
    var primaryCTA: String = "Choose plan"
    var onContinue: (() -> Void)? = nil
    var showsTrustRow: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                header

                VStack(spacing: LaylaSpacing.md) {
                    ForEach(plans) { plan in
                        planCard(plan)
                    }
                }

                Text("Need just one occasion? Try our event rental.")
                    .font(.laylaCaption)
                    .foregroundStyle(.laylaMuted)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, LaylaSpacing.sm)

                if showsTrustRow {
                    trustRow
                        .padding(.top, LaylaSpacing.md)
                }

                if let onContinue {
                    LaylaButton(title: primaryCTA, kind: .primary) {
                        onContinue()
                    }
                    .disabled(selection == nil)
                    .opacity(selection == nil ? 0.45 : 1)
                    .padding(.top, LaylaSpacing.md)
                }
            }
            .padding(.horizontal, LaylaSpacing.lg)
            .padding(.vertical, LaylaSpacing.lg)
        }
        .background(Color.laylaCream.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
            Text("Choose your closet").font(.laylaDisplay).foregroundStyle(.laylaInk)
            Text("Pause, swap, or cancel anytime.")
                .font(.laylaBody).foregroundStyle(.laylaMuted)
        }
    }

    @ViewBuilder
    private func planCard(_ plan: SubscriptionPlan) -> some View {
        let isSelected = selection?.id == plan.id
        Button {
            selection = plan
        } label: {
            LaylaCard(
                background: .laylaSurface,
                stroke: plan.isFeatured ? Color.laylaOlive : (isSelected ? Color.laylaOlive : Color.laylaBorder)
            ) {
                VStack(alignment: .leading, spacing: LaylaSpacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(plan.name)
                                .font(.laylaHeadline).foregroundStyle(.laylaInk)
                            Text(plan.tagline)
                                .font(.laylaCaption).foregroundStyle(.laylaMuted)
                        }
                        Spacer()
                        if plan.isFeatured {
                            LaylaBadge(title: "Most Popular")
                        }
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(priceText(plan.pricePerMonth))
                            .font(.system(.title, design: .serif).weight(.medium))
                            .foregroundStyle(.laylaOlive)
                        Text("/mo")
                            .font(.laylaCaption).foregroundStyle(.laylaMuted)
                    }

                    VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
                        ForEach(plan.features, id: \.self) { feat in
                            HStack(alignment: .top, spacing: LaylaSpacing.sm) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.laylaSuccess)
                                    .font(.caption.weight(.bold))
                                Text(feat)
                                    .font(.laylaBody)
                                    .foregroundStyle(.laylaInk)
                                Spacer()
                            }
                        }
                    }

                    HStack {
                        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(isSelected ? .laylaOlive : .laylaMuted)
                        Text(isSelected ? "Selected" : "Tap to select")
                            .font(.laylaCaption).foregroundStyle(.laylaMuted)
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint(isSelected ? "Selected" : "Double tap to select \(plan.name)")
    }

    private var trustRow: some View {
        HStack(spacing: LaylaSpacing.md) {
            trustItem(symbol: "arrow.uturn.backward", text: "Cancel anytime")
            trustItem(symbol: "shield.checkered", text: "No damage fees")
            trustItem(symbol: "leaf", text: "PERC-free cleaning")
        }
    }

    private func trustItem(symbol: String, text: String) -> some View {
        VStack(spacing: LaylaSpacing.xs) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.laylaOlive)
            Text(text)
                .font(.caption2)
                .foregroundStyle(.laylaMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func priceText(_ d: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 0
        return f.string(from: d as NSDecimalNumber) ?? "$\(d)"
    }
}

#Preview {
    StatefulPreviewWrapper(SubscriptionPlan?.none) { selection in
        PlansView(selection: selection, primaryCTA: "Continue") {}
    }
}

private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    let content: (Binding<Value>) -> Content

    init(_ initial: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initial)
        self.content = content
    }

    var body: some View { content($value) }
}
