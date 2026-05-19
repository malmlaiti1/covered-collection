import Foundation
import Observation

@Observable
final class UserProfileStore {
    static let onboardingFlagKey = "hasCompletedOnboarding"

    var profile: UserProfile = UserProfile()

    // MARK: - Bootstrap

    func bootstrap() async {
        if let saved = try? await PersistenceManager.shared.loadUserProfile() {
            profile = saved
        }
    }

    // MARK: - Mutations

    func toggleSaved(_ id: UUID) {
        if profile.savedProducts.contains(id) {
            profile.savedProducts.remove(id)
        } else {
            profile.savedProducts.insert(id)
        }
        persist()
    }

    func addToQueue(_ id: UUID) {
        guard !profile.queue.contains(id) else { return }
        profile.queue.append(id)
        persist()
    }

    func setCurrentPlan(_ plan: SubscriptionPlan) {
        profile.currentPlan = plan
        persist()
    }

    func completeOnboarding(profile newProfile: UserProfile) async {
        profile = newProfile
        UserDefaults.standard.set(true, forKey: Self.onboardingFlagKey)
        persist()
    }

    // MARK: - Private

    private func persist() {
        Task {
            try? await PersistenceManager.shared.saveUserProfile(profile)
        }
    }
}
