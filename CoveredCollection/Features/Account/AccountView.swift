import SwiftUI

struct AccountView: View {
    @Environment(UserProfileStore.self) private var store
    @Environment(ThemeStore.self) private var theme
    @AppStorage("isSignedIn") private var isSignedIn = false
    @State private var path: [AccountRoute] = []
    @State private var draftPlanSelection: SubscriptionPlan? = nil
    @State private var showSignOutConfirm = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: CoveredSpacing.md) {
                    profileCard
                    dnaCard
                    planCard
                    preferencesCard
                    themeCard
                    supportCard

                    #if DEBUG
                    devCard
                    #endif
                }
                .padding(.horizontal, CoveredSpacing.lg)
                .padding(.top, 4)
                .padding(.bottom, CoveredSpacing.xl * 2)
            }
            .background(Color.coveredCream.ignoresSafeArea())
            .navigationTitle("Account")
            .toolbarBackground(Color.coveredCream, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: AccountRoute.self) { route in
                switch route {
                case .managePlan:
                    PlansView(
                        selection: $draftPlanSelection,
                        primaryCTA: "Update plan"
                    ) {
                        if let plan = draftPlanSelection {
                            store.setCurrentPlan(plan)
                            path.removeLast()
                        }
                    }
                    .navigationTitle("My Plan")
                case .editModestyDNA:
                    DNAReadOnlyView(dna: store.profile.modestyDNA)
                case .savedItems:
                    SavedView()
                }
            }
        }
        .onAppear {
            draftPlanSelection = store.profile.currentPlan
        }
    }

    // MARK: - Profile

    private var profileCard: some View {
        CoveredCard(padding: 16) {
            HStack(spacing: 14) {
                Circle()
                    .fill(Color.coveredOlive)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(String(store.profile.firstName.prefix(1)))
                            .font(.system(.title2, design: .serif).weight(.medium))
                            .foregroundStyle(.coveredCream)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.profile.firstName)
                        .font(.coveredTitle)
                        .foregroundStyle(.coveredInk)
                    Text("Member since March 2026")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.coveredMuted)
            }
        }
    }

    // MARK: - DNA

    private var dnaCard: some View {
        Button { path.append(.editModestyDNA) } label: {
            CoveredCard(background: .coveredTagBg, stroke: nil, padding: 16) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Your Modesty DNA")
                            .coveredSmallCaps()
                            .foregroundStyle(.coveredMuted)
                        Spacer()
                        Text("Edit")
                            .font(.coveredCaption.weight(.semibold))
                            .foregroundStyle(.coveredOlive)
                    }
                    ModestyDNABadgeRow(dna: store.profile.modestyDNA, compact: false)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Plan

    private var planCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "My Plan")
            Button { path.append(.managePlan) } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(store.profile.currentPlan?.name ?? "No plan yet")
                            .font(.coveredBodyEmph)
                            .foregroundStyle(.coveredInk)
                        Text(store.profile.currentPlan?.tagline ?? "Tap to choose a plan")
                            .font(.coveredCaption)
                            .foregroundStyle(.coveredMuted)
                    }
                    Spacer()
                    Text("Change")
                        .font(.coveredCaption.weight(.semibold))
                        .foregroundStyle(.coveredOlive)
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(.coveredMuted)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            if store.profile.currentPlan != nil {
                Divider().padding(.leading, 16)
                HStack {
                    Text("Next charge")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredMuted)
                    Spacer()
                    if let p = store.profile.currentPlan {
                        Text(verbatim: "$\(p.pricePerMonth) · \(nextChargeText)")
                            .font(.coveredCaption.weight(.medium))
                            .foregroundStyle(.coveredInk)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
    }

    private var nextChargeText: String {
        let next = Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
        return next.formatted(.dateTime.month(.abbreviated).day())
    }

    // MARK: - Preferences

    private var preferencesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Preferences")
            preferenceRow(icon: "wand.and.stars", label: "Modesty DNA", trailing: nil) {
                path.append(.editModestyDNA)
            }
            Divider().padding(.leading, 46)
            preferenceRow(icon: "heart", label: "Saved items", trailing: "\(store.profile.savedProducts.count)") {
                path.append(.savedItems)
            }
            Divider().padding(.leading, 46)
            preferenceRow(icon: "calendar", label: "Occasions", trailing: "\(MockData.events.count)", action: nil)
            Divider().padding(.leading, 46)
            preferenceRow(icon: "shippingbox", label: "Box history", trailing: nil, action: nil)
        }
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func preferenceRow(icon: String, label: String, trailing: String?, action: (() -> Void)?) -> some View {
        let row = HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.coveredOlive)
                .frame(width: 22)
            Text(label)
                .font(.coveredBody)
                .foregroundStyle(.coveredInk)
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.coveredCaption)
                    .foregroundStyle(.coveredMuted)
            }
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.coveredMuted)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)

        if let action {
            Button(action: action) { row }
                .buttonStyle(.plain)
        } else {
            row
        }
    }

    // MARK: - Theme picker

    private var themeCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Theme")
            VStack(alignment: .leading, spacing: 12) {
                Text("Accent color")
                    .font(.coveredBody)
                    .foregroundStyle(.coveredInk)
                Text(theme.accent.displayName)
                    .font(.coveredCaption)
                    .foregroundStyle(.coveredMuted)
                HStack(spacing: 14) {
                    ForEach(BrandAccent.allCases) { accent in
                        Button {
                            theme.accent = accent
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(accent.primary)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.coveredCream, lineWidth: 2)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                accent == theme.accent ? accent.primaryDark : Color.coveredBorder,
                                                lineWidth: accent == theme.accent ? 2.5 : 1
                                            )
                                            .padding(-3)
                                    )
                                if accent == theme.accent {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.coveredCream)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(accent.displayName)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
    }

    // MARK: - Support

    private var supportCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            supportRow("Shipping & returns", isDestructive: false)
            Divider().padding(.leading, 16)
            supportRow("Refer a friend · earn $25", isDestructive: false)
            Divider().padding(.leading, 16)
            supportRow("Contact support", isDestructive: false)
            Divider().padding(.leading, 16)
            supportRow("Sign out", isDestructive: true) {
                showSignOutConfirm = true
            }
        }
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
        .confirmationDialog(
            "Sign out of your account?",
            isPresented: $showSignOutConfirm,
            titleVisibility: .visible
        ) {
            Button("Sign Out", role: .destructive) {
                signOut()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func supportRow(_ title: String, isDestructive: Bool, action: (() -> Void)? = nil) -> some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(title)
                    .font(.coveredBody)
                    .foregroundStyle(isDestructive ? Color(red: 0.616, green: 0.435, blue: 0.376) : Color.coveredInk)
                Spacer()
                if !isDestructive {
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(.coveredMuted)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }

    private func signOut() {
        isSignedIn = false
        #if DEBUG
        DevModeStore.shared.logout()
        #endif
    }

    // MARK: - Dev

    #if DEBUG
    private var devCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Developer")
            Button(role: .destructive) {
                UserDefaults.standard.set(false, forKey: UserProfileStore.onboardingFlagKey)
                Task {
                    try? await PersistenceManager.shared.deleteUserProfile()
                    exit(0)
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset Onboarding")
                    Spacer()
                }
                .font(.coveredBody)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .foregroundStyle(Color(red: 0.616, green: 0.435, blue: 0.376))
            }
            .buttonStyle(.plain)
        }
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
    }
    #endif
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .coveredSmallCaps()
            .foregroundStyle(.coveredMuted)
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - DNA detail (unchanged)

private struct DNAReadOnlyView: View {
    let dna: ModestyDNA

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                Text("Your Modesty DNA")
                    .font(.coveredDisplay).foregroundStyle(.coveredInk)
                Text("Editing axes will land in a future release.")
                    .font(.coveredCaption).foregroundStyle(.coveredMuted)
                ModestyDNABadgeRow(dna: dna, compact: false)
                Divider()
                axisRow("Neckline",   dna.neckline.displayName)
                axisRow("Sleeve",     dna.sleeve.displayName)
                axisRow("Hem",        dna.hem.displayName)
                axisRow("Opacity",    dna.opacity.displayName)
                axisRow("Silhouette", dna.silhouette.displayName)
                if !dna.optionalTags.isEmpty {
                    Divider().padding(.top, CoveredSpacing.sm)
                    Text("Tags").coveredSmallCaps().foregroundStyle(.coveredMuted)
                    FlowTags(tags: Array(dna.optionalTags))
                }
            }
            .padding(CoveredSpacing.lg)
        }
        .background(Color.coveredCream.ignoresSafeArea())
    }

    private func axisRow(_ k: String, _ v: String) -> some View {
        HStack {
            Text(k).font(.coveredCaption).foregroundStyle(.coveredMuted)
            Spacer()
            Text(v).font(.coveredBody).foregroundStyle(.coveredInk)
        }
    }
}

private struct FlowTags: View {
    let tags: [ModestyTag]
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 140), spacing: CoveredSpacing.sm)]
        LazyVGrid(columns: columns, spacing: CoveredSpacing.sm) {
            ForEach(tags) { tag in
                CoveredTag(title: tag.displayName, systemImage: tag.symbol)
            }
        }
    }
}

#Preview {
    AccountView()
        .environment(UserProfileStore())
        .environment(ThemeStore.shared)
}
