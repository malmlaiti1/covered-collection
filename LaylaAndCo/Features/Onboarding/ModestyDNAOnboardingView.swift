import SwiftUI

struct ModestyDNAOnboardingView: View {
    @Environment(UserProfileStore.self) private var store
    @State private var vm = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {
            header
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            footer
        }
        .background(Color.laylaCream.ignoresSafeArea())
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: LaylaSpacing.sm) {
            HStack {
                if vm.step.rawValue > 0 {
                    Button {
                        vm.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.laylaInk)
                            .padding(8)
                    }
                    .accessibilityLabel("Back")
                }
                Spacer()
                Text("Layla & Co.")
                    .font(.system(.subheadline, design: .serif).weight(.medium))
                    .foregroundStyle(.laylaInk)
                Spacer()
                if vm.step.rawValue > 0 {
                    // Symmetry spacer for alignment of the wordmark
                    Color.clear.frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, LaylaSpacing.lg)
            .padding(.top, LaylaSpacing.md)

            progressDots
                .padding(.top, LaylaSpacing.sm)
        }
        .padding(.bottom, LaylaSpacing.md)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<vm.totalSteps, id: \.self) { idx in
                Capsule()
                    .fill(idx == vm.step.rawValue ? Color.laylaOlive : Color.laylaBorder)
                    .frame(width: idx == vm.step.rawValue ? 22 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: vm.step)
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        @Bindable var vm = vm
        ScrollView {
            VStack(spacing: LaylaSpacing.lg) {
                switch vm.step {
                case .neckline:
                    AxisStepView(
                        title: "Necklines you'll wear",
                        subtitle: "Pick the most open you're comfortable with.",
                        options: Neckline.allCases,
                        label: { $0.displayName },
                        symbol: { neckSymbol(for: $0) },
                        selection: bindingForNeckline()
                    )
                case .sleeve:
                    AxisStepView(
                        title: "Sleeve length",
                        subtitle: "We'll prioritize this when curating your box.",
                        options: SleeveLength.allCases,
                        label: { $0.displayName },
                        symbol: { sleeveSymbol(for: $0) },
                        selection: bindingForSleeve()
                    )
                case .hem:
                    AxisStepView(
                        title: "Hem length",
                        subtitle: "Where should hems land?",
                        options: HemLength.allCases,
                        label: { $0.displayName },
                        symbol: { hemSymbol(for: $0) },
                        selection: bindingForHem()
                    )
                case .opacity:
                    AxisStepView(
                        title: "Fabric opacity",
                        subtitle: "Lined, opaque, or sheer-friendly?",
                        options: Opacity.allCases,
                        label: { $0.displayName },
                        symbol: { opacitySymbol(for: $0) },
                        selection: bindingForOpacity()
                    )
                case .silhouette:
                    AxisStepView(
                        title: "Silhouette",
                        subtitle: "How fitted do you like your clothes?",
                        options: Silhouette.allCases,
                        label: { $0.displayName },
                        symbol: { silhouetteSymbol(for: $0) },
                        selection: bindingForSilhouette()
                    )
                case .tags:
                    TagsStepView(tags: $vm.tags)
                case .plan:
                    PlansView(
                        selection: $vm.selectedPlan,
                        primaryCTA: "Continue with this plan",
                        onContinue: nil,
                        showsTrustRow: true
                    )
                case .success:
                    SuccessStepView(
                        firstName: vm.firstName,
                        dna: vm.dna
                    ) {
                        Task {
                            await store.completeOnboarding(profile: vm.buildProfile())
                        }
                    }
                }
            }
            .padding(.vertical, LaylaSpacing.lg)
        }
    }

    // MARK: - Footer

    @ViewBuilder
    private var footer: some View {
        if vm.step != .success {
            VStack(spacing: LaylaSpacing.sm) {
                LaylaButton(
                    title: vm.step == .plan ? "Continue with selected plan" : "Continue",
                    kind: .primary
                ) {
                    vm.advance()
                }
                .disabled(!vm.canContinue)
                .opacity(vm.canContinue ? 1.0 : 0.45)
            }
            .padding(.horizontal, LaylaSpacing.lg)
            .padding(.bottom, LaylaSpacing.lg)
        }
    }

    // MARK: - Bindings (hand-rolled to keep vm var binding simple)

    private func bindingForNeckline() -> Binding<Neckline> {
        Binding(get: { vm.neckline }, set: { vm.neckline = $0 })
    }
    private func bindingForSleeve() -> Binding<SleeveLength> {
        Binding(get: { vm.sleeve }, set: { vm.sleeve = $0 })
    }
    private func bindingForHem() -> Binding<HemLength> {
        Binding(get: { vm.hem }, set: { vm.hem = $0 })
    }
    private func bindingForOpacity() -> Binding<Opacity> {
        Binding(get: { vm.opacity }, set: { vm.opacity = $0 })
    }
    private func bindingForSilhouette() -> Binding<Silhouette> {
        Binding(get: { vm.silhouette }, set: { vm.silhouette = $0 })
    }

    // MARK: - SF Symbols per axis option

    private func neckSymbol(for n: Neckline) -> String {
        switch n {
        case .high: "rectangle.portrait.fill"
        case .modestScoop: "rectangle.portrait"
        case .vNeck: "triangle"
        case .openOK: "circle"
        }
    }
    private func sleeveSymbol(for s: SleeveLength) -> String {
        switch s {
        case .long: "arrow.down.to.line"
        case .threeQuarter: "arrow.down"
        case .elbow: "arrow.down.right"
        case .short: "arrow.right"
        case .sleevelessOK: "circle.dashed"
        }
    }
    private func hemSymbol(for h: HemLength) -> String {
        switch h {
        case .anklePlus: "ruler"
        case .midi: "ruler.fill"
        case .knee: "minus"
        case .aboveKneeOK: "ellipsis"
        }
    }
    private func opacitySymbol(for o: Opacity) -> String {
        switch o {
        case .fullyOpaque: "circle.fill"
        case .linedRequired: "circle.lefthalf.filled"
        case .sheerWithSlipOK: "circle"
        }
    }
    private func silhouetteSymbol(for s: Silhouette) -> String {
        switch s {
        case .veryLoose: "wind"
        case .relaxed: "figure.stand"
        case .tailored: "figure.walk"
        case .fittedOK: "figure.run"
        }
    }
}

#Preview {
    ModestyDNAOnboardingView()
        .environment(UserProfileStore())
}
