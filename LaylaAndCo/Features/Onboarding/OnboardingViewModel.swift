import SwiftUI
import Observation

@MainActor
@Observable
final class OnboardingViewModel {

    enum Step: Int, CaseIterable {
        case neckline = 0, sleeve, hem, opacity, silhouette, tags, plan, success
        var isAxisStep: Bool { rawValue <= Step.silhouette.rawValue }
    }

    var step: Step = .neckline
    var firstName: String = "Amina"

    var neckline: Neckline = .high
    var sleeve: SleeveLength = .long
    var hem: HemLength = .anklePlus
    var opacity: Opacity = .fullyOpaque
    var silhouette: Silhouette = .relaxed
    var tags: Set<ModestyTag> = [.hijabFriendly, .prayerFriendly]
    var selectedPlan: SubscriptionPlan? = nil

    var dna: ModestyDNA {
        ModestyDNA(
            neckline: neckline,
            sleeve: sleeve,
            hem: hem,
            opacity: opacity,
            silhouette: silhouette,
            optionalTags: tags
        )
    }

    var totalAxisSteps: Int { 5 }
    var totalSteps: Int { Step.allCases.count }

    var canContinue: Bool {
        switch step {
        case .plan: return selectedPlan != nil
        default:    return true
        }
    }

    func advance() {
        guard let next = Step(rawValue: step.rawValue + 1) else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            step = next
        }
    }

    func goBack() {
        guard let prev = Step(rawValue: step.rawValue - 1) else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            step = prev
        }
    }

    func toggleTag(_ tag: ModestyTag) {
        if tags.contains(tag) { tags.remove(tag) } else { tags.insert(tag) }
    }

    func buildProfile() -> UserProfile {
        UserProfile(
            firstName: firstName,
            modestyDNA: dna,
            currentPlan: selectedPlan,
            queue: [],
            currentBox: [],
            savedProducts: []
        )
    }
}
