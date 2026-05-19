import Foundation
import Observation

@Observable
final class OnboardingViewModel {

    enum Step: Int, CaseIterable {
        case neckline, sleeve, hem, opacity, silhouette, tags, plan, success
    }

    var step: Step = .neckline
    var neckline: Neckline     = .modestScoop
    var sleeve: SleeveLength   = .long
    var hem: HemLength         = .midi
    var opacity: Opacity       = .fullyOpaque
    var silhouette: Silhouette = .relaxed
    var tags: Set<ModestyTag>  = []
    var selectedPlan: SubscriptionPlan? = nil
    var firstName: String = ""

    var totalSteps: Int { Step.allCases.count }

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

    var canContinue: Bool {
        switch step {
        case .neckline, .sleeve, .hem, .opacity, .silhouette, .tags: return true
        case .plan:    return selectedPlan != nil
        case .success: return true
        }
    }

    func advance() {
        guard let next = Step(rawValue: step.rawValue + 1) else { return }
        step = next
    }

    func goBack() {
        guard let prev = Step(rawValue: step.rawValue - 1) else { return }
        step = prev
    }

    func buildProfile() -> UserProfile {
        UserProfile(
            firstName: firstName.isEmpty ? "Amina" : firstName,
            currentPlan: selectedPlan,
            modestyDNA: dna,
            savedProducts: [],
            currentBox: [],
            queue: []
        )
    }
}
