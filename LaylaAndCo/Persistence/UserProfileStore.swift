import SwiftUI
import Observation

@MainActor
@Observable
final class UserProfileStore {

    /// Backing key for the @AppStorage flag the app shell reads.
    static let onboardingFlagKey = "hasCompletedOnboarding"

    /// Live profile in memory. Starts as Amina (in-memory only) until onboarding completes
    /// or until a persisted profile is loaded from disk.
    var profile: UserProfile

    /// True once onboarding finishes and the profile is on disk.
    var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: Self.onboardingFlagKey)
        }
    }

    private let persistence: PersistenceManager

    init(persistence: PersistenceManager = .shared,
         initialProfile: UserProfile = .amina) {
        self.persistence = persistence
        self.profile = initialProfile
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Self.onboardingFlagKey)
    }

    /// Called once from `AppRoot.task`; reads the persisted profile if present.
    func bootstrap() async {
        if let loaded = await persistence.loadUserProfile() {
            self.profile = loaded
        }
    }

    /// Single transaction that gates onboarding → MainTabView.
    func completeOnboarding(profile: UserProfile) async {
        self.profile = profile
        do {
            try await persistence.saveUserProfile(profile)
            self.hasCompletedOnboarding = true
        } catch {
            // Even if disk write fails we still flip the flag so the user isn't stuck;
            // a real backend in Phase 2 would retry.
            self.hasCompletedOnboarding = true
        }
    }

    func toggleSaved(_ id: UUID) {
        if profile.savedProducts.contains(id) {
            profile.savedProducts.remove(id)
        } else {
            profile.savedProducts.insert(id)
        }
        Task { try? await persistence.saveUserProfile(profile) }
    }

    func addToQueue(_ id: UUID) {
        guard !profile.queue.contains(id) else { return }
        profile.queue.append(id)
        Task { try? await persistence.saveUserProfile(profile) }
    }

    func setCurrentPlan(_ plan: SubscriptionPlan?) {
        profile.currentPlan = plan
        Task { try? await persistence.saveUserProfile(profile) }
    }

    func updateDNA(_ dna: ModestyDNA) {
        profile.modestyDNA = dna
        Task { try? await persistence.saveUserProfile(profile) }
    }
}
