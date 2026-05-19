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
        .background(Color.coveredCream.ignoresSafeArea())
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: CoveredSpacing.sm) {
            HStack {
                if vm.step.rawValue > 0 {
                    Button {
                        vm.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.coveredInk)
                            .padding(8)
                    }
                    .accessibilityLabel("Back")
                }
                Spacer()
                Text("The Covered Collection")
                    .font(.system(.subheadline, design: .serif).weight(.medium))
                    .foregroundStyle(.coveredInk)
                Spacer()
                if vm.step.rawValue > 0 {
                    Color.clear.frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, CoveredSpacing.lg)
            .padding(.top, CoveredSpacing.md)

            progressDots
                .padding(.top, CoveredSpacing.sm)
        }
        .padding(.bottom, CoveredSpacing.md)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<vm.totalSteps, id: \.self) { idx in
                Capsule()
                    .fill(idx == vm.step.rawValue ? Color.coveredOlive : Color.coveredBorder)
                    .frame(width: idx == vm.step.rawValue ? 22 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: vm.step)
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        @Bindable var vm = vm
        switch vm.step {
        case .neckline:
            centeredAxis(
                AxisStepView(
                    title: "Necklines you'll wear",
                    subtitle: "Pick the most open you're comfortable with.",
                    options: Neckline.allCases,
                    label: { $0.displayName },
                    symbol: { neckSymbol(for: $0) },
                    selection: bindingForNeckline()
                )
            )
        case .sleeve:
            centeredAxis(
                AxisStepView(
                    title: "Sleeve length",
                    subtitle: "We'll prioritize this when curating your box.",
                    options: SleeveLength.allCases,
                    label: { $0.displayName },
                    symbol: { sleeveSymbol(for: $0) },
                    selection: bindingForSleeve()
                )
            )
        case .hem:
            centeredAxis(
                AxisStepView(
                    title: "Hem length",
                    subtitle: "Where should hems land?",
                    options: HemLength.allCases,
                    label: { $0.displayName },
                    symbol: { hemSymbol(for: $0) },
                    selection: bindingForHem()
                )
            )
        case .opacity:
            centeredAxis(
                AxisStepView(
                    title: "Fabric opacity",
                    subtitle: "Lined, opaque, or sheer-friendly?",
                    options: Opacity.allCases,
                    label: { $0.displayName },
                    symbol: { opacitySymbol(for: $0) },
                    selection: bindingForOpacity()
                )
            )
        case .silhouette:
            centeredAxis(
                AxisStepView(
                    title: "Silhouette",
                    subtitle: "How fitted do you like your clothes?",
                    options: Silhouette.allCases,
                    label: { $0.displayName },
                    symbol: { silhouetteSymbol(for: $0) },
                    selection: bindingForSilhouette()
                )
            )
        case .tags:
            ScrollView {
                TagsStepView(tags: $vm.tags)
                    .padding(.vertical, CoveredSpacing.lg)
            }
        case .plan:
            ScrollView {
                PlansView(
                    selection: $vm.selectedPlan,
                    primaryCTA: "Continue with this plan",
                    onContinue: nil,
                    showsTrustRow: true
                )
                .padding(.vertical, CoveredSpacing.lg)
            }
        case .success:
            ScrollView {
                SuccessStepView(
                    firstName: vm.firstName,
                    dna: vm.dna
                ) {
                    Task {
                        await store.completeOnboarding(profile: vm.buildProfile())
                    }
                }
                .padding(.vertical, CoveredSpacing.lg)
            }
        }
    }

    /// Wraps an axis step in a vertically-centered container with safety
    /// scrolling for accessibility text sizes.
    @ViewBuilder
    private func centeredAxis<V: View>(_ view: V) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer(minLength: CoveredSpacing.lg)
                view
                Spacer(minLength: CoveredSpacing.lg)
            }
            .frame(minHeight: UIScreen.main.bounds.height * 0.55)
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Footer

    @ViewBuilder
    private var footer: some View {
        if vm.step != .success {
            VStack(spacing: CoveredSpacing.sm) {
                CoveredButton(
                    title: vm.step == .plan ? "Continue with selected plan" : "Continue",
                    kind: .primary
                ) {
                    vm.advance()
                }
                .disabled(!vm.canContinue)
                .opacity(vm.canContinue ? 1.0 : 0.45)
            }
            .padding(.horizontal, CoveredSpacing.lg)
            .padding(.bottom, CoveredSpacing.lg)
        }
    }

    // MARK: - Bindings

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
