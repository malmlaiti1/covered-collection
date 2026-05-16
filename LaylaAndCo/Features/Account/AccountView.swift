import SwiftUI

struct AccountView: View {
    @Environment(UserProfileStore.self) private var store
    @State private var path: [AccountRoute] = []
    @State private var draftPlanSelection: SubscriptionPlan? = nil

    var body: some View {
        NavigationStack(path: $path) {
            List {
                profileSection
                planSection
                preferencesSection

                #if DEBUG
                Section("Developer") {
                    Button(role: .destructive) {
                        UserDefaults.standard.set(false, forKey: UserProfileStore.onboardingFlagKey)
                        Task {
                            try? await PersistenceManager.shared.deleteUserProfile()
                            exit(0)
                        }
                    } label: {
                        Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                    }
                }
                #endif
            }
            .scrollContentBackground(.hidden)
            .background(Color.laylaCream.ignoresSafeArea())
            .navigationTitle("Account")
            .toolbarBackground(Color.laylaCream, for: .navigationBar)
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

    private var profileSection: some View {
        Section {
            HStack(spacing: LaylaSpacing.md) {
                Circle()
                    .fill(Color.laylaOlive)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(String(store.profile.firstName.prefix(1)))
                            .font(.laylaHeadline)
                            .foregroundStyle(.laylaCream)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.profile.firstName)
                        .font(.laylaTitle)
                        .foregroundStyle(.laylaInk)
                    Text("Layla & Co. member")
                        .font(.laylaCaption)
                        .foregroundStyle(.laylaMuted)
                }
            }
            .padding(.vertical, LaylaSpacing.sm)
        }
        .listRowBackground(Color.laylaSurface)
    }

    private var planSection: some View {
        Section("My Plan") {
            NavigationLink(value: AccountRoute.managePlan) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(store.profile.currentPlan?.name ?? "No plan yet")
                            .font(.laylaBodyEmph)
                            .foregroundStyle(.laylaInk)
                        if let plan = store.profile.currentPlan {
                            Text(plan.tagline)
                                .font(.laylaCaption)
                                .foregroundStyle(.laylaMuted)
                        } else {
                            Text("Tap to choose a plan")
                                .font(.laylaCaption)
                                .foregroundStyle(.laylaMuted)
                        }
                    }
                    Spacer()
                    Text("Change plan")
                        .font(.laylaCaption)
                        .foregroundStyle(.laylaOlive)
                }
            }
        }
        .listRowBackground(Color.laylaSurface)
    }

    private var preferencesSection: some View {
        Section("Preferences") {
            NavigationLink(value: AccountRoute.editModestyDNA) {
                Label("Modesty DNA", systemImage: "person.crop.square")
            }
            NavigationLink(value: AccountRoute.savedItems) {
                Label("Saved items", systemImage: "heart")
            }
        }
        .listRowBackground(Color.laylaSurface)
    }
}

private struct DNAReadOnlyView: View {
    let dna: ModestyDNA

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                Text("Your Modesty DNA")
                    .font(.laylaDisplay).foregroundStyle(.laylaInk)
                Text("Editing axes will land in a future release.")
                    .font(.laylaCaption).foregroundStyle(.laylaMuted)
                ModestyDNABadgeRow(dna: dna, compact: false)
                Divider()
                axisRow("Neckline",   dna.neckline.displayName)
                axisRow("Sleeve",     dna.sleeve.displayName)
                axisRow("Hem",        dna.hem.displayName)
                axisRow("Opacity",    dna.opacity.displayName)
                axisRow("Silhouette", dna.silhouette.displayName)
                if !dna.optionalTags.isEmpty {
                    Divider().padding(.top, LaylaSpacing.sm)
                    Text("Tags").laylaSmallCaps().foregroundStyle(.laylaMuted)
                    FlowTags(tags: Array(dna.optionalTags))
                }
            }
            .padding(LaylaSpacing.lg)
        }
        .background(Color.laylaCream.ignoresSafeArea())
    }

    private func axisRow(_ k: String, _ v: String) -> some View {
        HStack {
            Text(k).font(.laylaCaption).foregroundStyle(.laylaMuted)
            Spacer()
            Text(v).font(.laylaBody).foregroundStyle(.laylaInk)
        }
    }
}

private struct FlowTags: View {
    let tags: [ModestyTag]
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 140), spacing: LaylaSpacing.sm)]
        LazyVGrid(columns: columns, spacing: LaylaSpacing.sm) {
            ForEach(tags) { tag in
                LaylaTag(title: tag.displayName, systemImage: tag.symbol)
            }
        }
    }
}

#Preview {
    AccountView()
        .environment(UserProfileStore())
}
